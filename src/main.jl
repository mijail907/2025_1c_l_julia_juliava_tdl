include("DataVisualization/dataVisualization.jl")
include("encontrarNumerosPrimos/buscarPrimos.jl")

using  .DataVisualization
using .Primos

function main()
    DataVisualization.dataVisualization()
    println(Primos.encontrar_primos(1, 100))
end

main()