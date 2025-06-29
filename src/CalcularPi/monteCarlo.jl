module CalcularPI

    using Random
    using Plots
    export calculatePI
    
    function calculatePI(pointAmount::Int)
        println("Calculo de PI con el método de Monte Carlo")

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

        println("Puntos dentro del círculo: $insideCircle")

        println("Pi estimado: $estimatedPi")


        theta = range(0, stop=2*pi, length=100) # Ángulos de 0 a 2*pi
        circulo_x = cos.(theta)
        circulo_y = sin.(theta)

        monteCarlo = plot(circulo_x, circulo_y,
            label="Círculo (radio 1)",
            aspect_ratio=:equal, # Mantiene la proporción para que el círculo no se vea elíptico
            xlims=(-1.1, 1.1), # Límites del eje X para que el cuadrado se vea bien
            ylims=(-1.1, 1.1), # Límites del eje Y
            title="Estimación de Pi con Monte Carlo ($pointAmount puntos)",
            xlabel="X",
            ylabel="Y",
            legend=:outertopright,
            color=:green,
            size=(800, 800) # Tamaño de la ventana del gráfico
        )

        plot!(monteCarlo, [-1, 1, 1, -1, -1], [-1, -1, 1, 1, -1],
            label="Cuadrado (lado 2)",
            linecolor=:black,
            linestyle=:dash,
            linewidth=1
        )

        scatter!(monteCarlo, pointsXInside, pointsYInside,
            label="Puntos dentro",
            color=:red,
            marker=:o, # Usar una 'o' para los puntos dentro
            markersize=2,
            alpha=0.6
        )

        scatter!(monteCarlo, pointsXOutside, pointsYOutside,
            label="Puntos fuera",
            color=:blue,
            marker=:x, # Usar una 'x' para los puntos fuera
            markersize=2,
            alpha=0.6
        )

        annotate!(monteCarlo, 1.8, 0.6, text("Pi estimado: $estimatedPi", :right, 10))

        mkpath("Salidas")
        savefig(monteCarlo, "Salidas/monteCarlo.png")
    end
    
end