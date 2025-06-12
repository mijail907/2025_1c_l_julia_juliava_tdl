module Pelotitas

    using Plots
    using Random
    using Base.Threads
    
    export simular_pelotitas

"""
struct Ball

Representa una pelotita con posición (x, y) y velocidad (vx, vy) en un espacio 2D.
"""

    mutable struct Ball
        x::Float64
        y::Float64
        vx::Float64
        vy::Float64
    end

"""
Crea un vector con `n` pelotitas (`Ball`) ubicadas en posiciones aleatorias dentro del espacio (0,1),
y con velocidades aleatorias pequeñas en ambas direcciones.
"""

    function crear_bolas(n)
        [Ball(rand(), rand(), randn() * 0.01, randn() * 0.01) for _ in 1:n]
    end

"""
actualizar_posiciones!(bolas::Vector{Ball})

Actualiza las posiciones de todas las pelotitas del vector bolas, aplicando su velocidad.
Si una pelotita choca contra un borde (x o y fuera del rango 0–1), invierte su dirección (rebote).

Esta operación se paraleliza con @threads para mayor rendimiento.
"""
    function actualizar_posiciones!(bolas)
        @threads for i in 1:length(bolas)
            b = bolas[i]
            b.x += b.vx
            b.y += b.vy

            if b.x < 0 || b.x > 1
                b.vx *= -1
            end
            if b.y < 0 || b.y > 1
                b.vy *= -1
            end
        end
    end

"""
dibujar(bolas::Vector{Ball}) -> Plot

Genera un gráfico tipo scatter con la posición actual de las pelotitas dentro del espacio 2D (0,1).
El gráfico no tiene leyenda y usa color rojo por defecto.
"""
    function dibujar(bolas)
        x = [b.x for b in bolas]
        y = [b.y for b in bolas]
        
        #scatter(x, y, xlim=(0,1), ylim=(0,1), legend=false, size=(400,400), title="Simulación de pelotitas")
        #scatter(x, y, xlim=(0,1), ylim=(0,1), legend=false, size=(400,400), title="Simulación de pelotitas", color=:blue)
        scatter(x, y, xlim=(0,1), ylim=(0,1), legend=false, size=(400,400), title="Simulación de pelotitas", color=:red)
    end

    
"""
simular_pelotitas()

Simula el movimiento de 2 pelotitas dentro de una caja 2D durante 50 fotogramas.
Genera una animación y la guarda como archivo pelotitas.gif en el directorio actual.
"""
    function simular_pelotitas()
        bolas = crear_bolas(2)
        anim = @animate for _ in 1:100
            actualizar_posiciones!(bolas)
            dibujar(bolas)
        end
        gif(anim, "pelotitas.gif", fps=20)
        
        println("GIF generado: pelotitas.gif")
        println("Número de hilos disponibles: ", Threads.nthreads())
    end
end
