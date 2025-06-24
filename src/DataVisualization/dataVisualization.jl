module DataVisualization

    using CSV
    using DataFrames
    using MLUtils
    using GLM
    using StatsModels
    using CategoricalArrays
    using Statistics
    using Plots
    using Random

    #=
        Se recibe un DataFrame, una columna A de este la cual indica los grupos y otra columna B con la cual se calcula el promedio de estos grupos
        Por ultimo se completa la columna B con estos promedios en las filas donde tiene missing Data
    =#
    function completarConPromedio(df:: DataFrame, grupo::Symbol, columna::Symbol)
        promedios = combine(groupby(df, grupo), columna => mean ∘ skipmissing => :promedio)

        df = leftjoin(df, promedios, on = grupo)
    
        df[!, columna] = coalesce.(df[!, columna], df[!, :promedio])
    
        select!(df, Not(:promedio))
    
        return df
    end

    #= 
        Se recibe un DataFrame y una columna de este en la cual se calcula los Outliers y se filtra estos
    =#
    function clearOutliers(df:: DataFrame, columna::Symbol)
        q1 = quantile(df[!, columna], 0.25)
        q3 = quantile(df[!, columna], 0.75)
        iqr = q3 - q1

        lower = q1 - 1.5 * iqr
        upper = q3 + 1.5 * iqr

        return df[(df[!, columna] .>= lower) .& (df[!, columna] .<= upper), :]
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

        #= Se filtran outliers de property_surface_total =#
        df = clearOutliers(df, :property_surface_total)
        
        df = clearOutliers(df, :property_surface_covered)

        df = clearOutliers(df, :property_price)

        return df
    end

    function plotPropertyType(df:: DataFrame)
        countType = combine(groupby(df, [:property_type]), nrow => :cantidad)

        barPlot = bar(
            countType.property_type,
            countType.cantidad,
            legend = false,
            title = "Tipos de propiedades en venta en Capital Federal en 2021",
            xlabel = "Tipo de propiedad",
            ylabel = "Cantidad",
            titlefont = 12,
            guidefont = font(10),
            tickfont = font(9),
            yformatter = y -> string(Int(round(y))),
            size=(700,400)
        )
        savefig(barPlot, "Salidas/barPlot.png")
    end

    function plotTotalM2Price(df:: DataFrame)
        totalM2Price = df.property_price ./ df.property_surface_total
        
        histograma = histogram(
            totalM2Price,
            bins = 40,
            xlabel = "Precio por m² total",
            ylabel = "Frecuencia",
            label = "y1",
            title = "Distribución de precios por m²",
            titlefont = 12,
            guidefont = font(10),
            tickfont = font(9),
            xformatter = x -> string(Int(round(x))),
            size=(700,400)
        )

        savefig(histograma, "Salidas/histograma.png")
    end

    function predictPrice(df:: DataFrame)
        Random.seed!(123)
        
        df.place_l3 = categorical(df.place_l3)

        df.property_type = categorical(df.property_type)
        
        df = shuffleobs(df)
        
        df_train_set, df_test_set = splitobs(df, at = 0.8)

        df_train = DataFrame(df_train_set)

        df_test = DataFrame(df_test_set)

        regresionLineal = lm(@formula(property_price ~ property_surface_total + property_surface_covered + place_l3 + property_type), df_train)

        predictions = predict(regresionLineal, df_test)

        y_pred = predict(regresionLineal)

        y_true = df_train.property_price

        # Se grafica la regresion lineal
        linearRegresion = scatter(
            y_true,
            y_pred,
            xlabel = "Valor real",
            ylabel = "Valor predicho",
            label = "",
            title = "Predicción del precio de propiedades usando tipo, ubicación y superficie",
            titlefont = 12,
            guidefont = font(10),
            tickfont = font(9),
            xformatter = x -> string(Int(round(x))),
            yformatter = y -> string(Int(round(y))),
            size=(800,500)
        )
        plot!(
            linearRegresion,
            [minimum(y_true), maximum(y_true)],
            [minimum(y_true), maximum(y_true)],
            lw = 2,
            l = :dash,
            label = "Precio Ideal",
            linecolor = :red
        )

        savefig(linearRegresion, "Salidas/linearRegresion.png")
    end

    export dataVisualization
    function dataVisualization()
        df = clearDataSet()
        mkpath("Salidas")
        plotPropertyType(df)
        plotTotalM2Price(df)
        predictPrice(df)
    end

end