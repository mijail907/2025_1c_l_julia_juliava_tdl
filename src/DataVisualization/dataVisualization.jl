module DataVisualization
    using CSV
    using DataFrames
    using Plots

    function plotAccidentes()
        df_victimas = CSV.read("../../dataSet/victimas.csv", DataFrame)

        countVictimas = combine(groupby(df_victimas, [:SEXO]), nrow => :count)

        graf1 = bar(countVictimas.SEXO, countVictimas.count, legend = false, title="Víctimas por sexo")
        display(graf1)
    end

    function plotAccidenteCalles()
        df = CSV.read("../../dataSet/hechos.csv", DataFrame)

        countAcusado = combine(groupby(df, [:TIPO_DE_CALLE]), nrow => :count)

        graf2 = bar(countAcusado.TIPO_DE_CALLE, countAcusado.count, legend = false, title="Accidentes por tipo de calle")
        display(graf2)
    end

    export dataVisualization
    function dataVisualization()
        plotAccidentes()
        plotAccidenteCalles()
    end

end