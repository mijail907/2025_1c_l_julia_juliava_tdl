include("DataVisualization/dataVisualization.jl")
include("CalcularPi/monteCarlo.jl")

using  .DataVisualization
using .CalcularPI

function main()
    DataVisualization.dataVisualization()
    CalcularPI.calculatePI(1000)
end

main()