include("DataVisualization/dataVisualization.jl")
include("CalcularPi/monteCarlo.jl")
include("Simulaciones/pelotitas.jl")
include("encontrarNumerosPrimos/buscarPrimos.jl")

using  .DataVisualization
using .CalcularPI
using .Pelotitas

using .Primos

function main()

    DataVisualization.dataVisualization()
    Pelotitas.simular_pelotitas()
    CalcularPI.calculatePI(1000)
    println(Primos.encontrar_primos(1, 100))
end

main()