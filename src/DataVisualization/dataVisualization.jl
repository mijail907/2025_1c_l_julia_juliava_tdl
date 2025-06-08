module DataVisualization
    using CSV
    using DataFrames
    using Statistics
    using Plots

    function completarConPromedio(df:: DataFrame, grupo::Symbol, columna::Symbol)
        promedios = combine(groupby(df, grupo), columna => mean ∘ skipmissing => :promedio)

        df = leftjoin(df, promedios, on = grupo)
    
        df[!, columna] = coalesce.(df[!, columna], df[!, :promedio])
    
        select!(df, Not(:promedio))
    
        return df
    end

    function clearDataSet()
        df = CSV.read("../../dataSet/properati_argentina_2021.csv", DataFrame)
        
        #= Se eliminan todas las columnas que en su totalidad tienen missing data =#
        select!(df, Not([name for name in names(df) if all(ismissing, df[!, name])]))

        #= Se cuenta la cantidad de missing data de las columnas =#
        missing_counts = Dict(name => count(ismissing, df[!, name]) for name in names(df))
        #= println(missing_counts) =#

        #= Se cuenta la cantidad de variedad de data que tiene opertarion =#
        opreacionCantidad = combine(groupby(df, :operation), nrow => :cantidad)
        #= println(opreacionCantidad) =#
        
        #= Se cuenta la cantidad de variedad de data que tiene place_l2 =#
        placeCantidad = combine(groupby(df, :place_l2), nrow => :cantidad)
        #= println(placeCantidad) =#

        #= Se cuenta la cantidad de variedad de data que tiene property_currency =#
        currencyCant = combine(groupby(df, :property_currency), nrow => :cantidad)
        #= println(currencyCant) =#

        #=
            Se elimina place_l4 al ver que tiene un gran porcentaje de columnas con missing data 
            Se elimina Column1, id y property_title ya que no aportan ningun valor que nos interese
            Se elimina operation ya que solo tiene el valor Venta
            Se elimina place_l2 ya que solo tiene el valor Capital Federal
            Se elimina property_currency ya que solo posee el valor USD
            Se eliminan start_date, end_date y created_on
        =#
        select!(df, Not(:place_l4, :Column1, :id, :operation, :place_l2, :property_title, :property_currency, :start_date, :end_date, :created_on, :property_bedrooms))

        #= Se eliminan los missing de las siguientes columnas =#
        dropmissing!(df, [:latitud, :longitud, :place_l3])

        #= Se calcula el promedio de property_surface_total para los tipos de propiedades y se completa los missing con este valor =#
        df = completarConPromedio(df, :property_type, :property_surface_total)
        
        #= Se calcula el promedio de property_surface_covered para los tipos de propiedades y se completa los missing con este valor =#
        df = completarConPromedio(df, :property_type, :property_surface_covered)

        return df
    end

    function plotPropertyType(df:: DataFrame)
        countType = combine(groupby(df, [:property_type]), nrow => :cantidad)

        graf1 = bar(countType.property_type, countType.cantidad, legend = false, title ="Tipos de propiedades en venta en Capital Federal en el año 2021")

        display(graf1)
    end

    function plotMapPropertys(df:: DataFrame)
        tipos = unique(df.property_type)

        # Asignar un color a cada tipo
        color_map = Dict(t => i for (i, t) in enumerate(tipos))
        colors = [color_map[t] for t in df.property_type]

        # Graficar
        scatter(df.longitud, df.latitud;
            group = df.property_type,
            legend = :topleft,
            title = "Propiedades en Capital Federal",
            xlabel = "Longitud", ylabel = "Latitud",
            markersize = 5,
            palette = :viridis)
    end

    export dataVisualization
    function dataVisualization()
        df = clearDataSet()
        plotPropertyType(df)
        plotMapPropertys(df)
    end

end