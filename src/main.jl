include("DataVisualization/dataVisualization.jl")
include("Simulaciones/pelotitas.jl")
using  .DataVisualization
using .Pelotitas

function main()
    #DataVisualization.dataVisualization()
    Pelotitas.simular_pelotitas()
end

main()