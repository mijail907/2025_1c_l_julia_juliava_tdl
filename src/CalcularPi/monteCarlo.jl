module CalcularPI

    using Random
    export calculatePI
    
    function calculatePI(pointAmount::Int)
        insideCircle = 0
        pointsXInside = Float64[]
        pointsYInside = Float64[]
        pointsXOutside = Float64[]
        pointsYOutside = Float64[]
        for _ in 1:pointAmount
            x = 2 * rand() -1
            y = 2 * rand() -1

            if x^2 + y^2 <= 1.0
                insideCircle += 1
                push!(pointsXInside, x)
                push!(pointsYInside, y)
            else
                push!(pointsXOutside, x)
                push!(pointsYOutside, y)
            end
        end

        estimatedPi = 4 * insideCircle/pointAmount

        println(estimatedPi)
    end
    
end