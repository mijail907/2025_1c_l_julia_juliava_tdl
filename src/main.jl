include("DataVisualization/dataVisualization.jl")
include("CalcularPi/monteCarlo.jl")
include("Simulaciones/pelotitas.jl")

using  .DataVisualization
using .CalcularPI
using .Pelotitas

function main()

    DataVisualization.dataVisualization()
    Pelotitas.simular_pelotitas()
    CalcularPI.calculatePI(1000)
end

main()