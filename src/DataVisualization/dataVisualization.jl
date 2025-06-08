# module DataVisualization
#     using CSV
#     using DataFrames
#     using Plots

#     function plotAccidentes()
#         df_victimas = CSV.read("../../dataSet/victimas.csv", DataFrame)

#         countVictimas = combine(groupby(df_victimas, [:SEXO]), nrow => :count)

#         graf1 = bar(countVictimas.SEXO, countVictimas.count, legend = false, title="Víctimas por sexo")
#         display(graf1)
#         savefig(graf1, "grafico1.png")
#     end

#     function plotAccidenteCalles()
#         df = CSV.read("../../dataSet/hechos.csv", DataFrame)

#         countAcusado = combine(groupby(df, [:TIPO_DE_CALLE]), nrow => :count)

#         graf2 = bar(countAcusado.TIPO_DE_CALLE, countAcusado.count, legend = false, title="Accidentes por tipo de calle")
#         display(graf2)
#     end

#     export dataVisualization
#     function dataVisualization()
#         plotAccidentes()
#         plotAccidenteCalles()
#     end

# end


module DataVisualization

    using CSV
    using DataFrames
    using Plots

    function plotAccidentes()
        ruta_victimas = joinpath(@__DIR__, "..", "..", "dataSet", "victimas.csv")
        df_victimas = CSV.read(ruta_victimas, DataFrame)

        countVictimas = combine(groupby(df_victimas, [:SEXO]), nrow => :count)

        graf1 = bar(countVictimas.SEXO, countVictimas.count, legend = false, title="Víctimas por sexo")
        display(graf1)
    end

    function plotAccidenteCalles()
        ruta_hechos = joinpath(@__DIR__, "..", "..", "dataSet", "hechos.csv")
        df = CSV.read(ruta_hechos, DataFrame)

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