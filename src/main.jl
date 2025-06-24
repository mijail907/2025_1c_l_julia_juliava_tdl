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

    # DataVisualization.dataVisualization()
    # Pelotitas.simular_pelotitas()
    # CalcularPI.calculatePI(1000)
    Primos.test_paralelismo()
end

main()