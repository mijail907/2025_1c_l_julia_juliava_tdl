include("DataVisualization/dataVisualization.jl")
include("CalcularPi/monteCarlo.jl")
include("Simulaciones/pelotitas.jl")
include("encontrarNumerosPrimos/buscarPrimos.jl")

using .DataVisualization
using .CalcularPI
using .Pelotitas
using .Primos

using Dates

function main()

    println("----------------------------------------------------------------------------------------------------------")
    Pelotitas.simular_pelotitas()
    println("----------------------------------------------------------------------------------------------------------")
    CalcularPI.calculatePI(1000)
    println("----------------------------------------------------------------------------------------------------------")
    Primos.test_paralelismo()
    DataVisualization.dataVisualization()
end

main()