include("DataVisualization/dataVisualization.jl")
include("Simulaciones/pelotitas.jl")
using  .DataVisualization
using .Pelotitas

function main()
    DataVisualization.dataVisualization()
    Simulaciones.simular_pelotitas()
end

main()