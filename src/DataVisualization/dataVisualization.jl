module DataVisualization
    using CSV
    using DataFrames
    using Plots

    function clearDataSet()
        df = CSV.read("../../dataSet/properati_argentina_2021.csv", DataFrame)
        
        #= Se eliminan todas las columnas que en su totalidad tienen missing data =#
        select!(df, Not([name for name in names(df) if all(ismissing, df[!, name])]))

        #= Se cuenta la cantidad de missing data de las columnas =#
        missing_counts = Dict(name => count(ismissing, df[!, name]) for name in names(df))
        println(missing_counts)

        #= Se cuenta la cantidad de variedad de data que tiene opertarion =#
        opreacionCantidad = combine(groupby(df, :operation), nrow => :cantidad)
        println(opreacionCantidad)
        
        #= Se cuenta la cantidad de variedad de data que tiene place_l2 =#
        placeCantidad = combine(groupby(df, :place_l2), nrow => :cantidad)
        println(placeCantidad)

        #= Se cuenta la cantidad de variedad de data que tiene property_currency =#
        currencyCant = combine(groupby(df, :property_currency), nrow => :cantidad)
        println(currencyCant)

        #=
            Se elimina place_l4 al ver que tiene un gran porcentaje de columnas con missing data 
            Se elimina Column1, id y property_title ya que no aportan ningun valor que nos interese
            Se elimina operation ya que solo tiene el valor Venta
            Se elimina place_l2 ya que solo tiene el valor Capital Federal
            Se elimina property_currency ya que solo posee el valor USD
            Se eliminan start_date, end_date y created_on
        =#
        select!(df, Not(:place_l4, :Column1, :id, :operation, :place_l2, :property_title, :property_currency, :start_date, :end_date, :created_on))
    end

    export dataVisualization
    function dataVisualization()
        clearDataSet()
    end

end