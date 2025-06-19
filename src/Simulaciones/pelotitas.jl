module Pelotitas

    using Plots
    using Random
    using Base.Threads
    using Dates
    
    export simular_pelotitas

"""
struct Ball

Representa una pelotita con posición (x, y) y velocidad (velocidadX, velocidadY) en un espacio 2D.
"""

    mutable struct Ball
        posicionX::Float64 #Posición horizontal (eje X) de la pelotita (entre 0 y 1)
        posicionY::Float64 #Posición vertical (eje Y) de la pelotita (entre 0 y 1)
        velocidadX::Float64 #Velocidad horizontal (qué tanto se mueve en X por frame)
        velocidadY::Float64 #Velocidad vertical (qué tanto se mueve en Y por frame)
    end

"""
Crea un vector con `n` pelotitas (`Ball`) ubicadas en posiciones aleatorias dentro del espacio (0,1),
y con velocidades aleatorias pequeñas en ambas direcciones.
"""

    function crear_bolas(n)
        [Ball(rand(), rand(), randn() * 0.01, randn() * 0.01) for _ in 1:n]
    end

"""
Actualiza las posiciones de todas las pelotitas del vector bolas, aplicando su velocidad.
Si una pelotita choca contra un borde (x o y fuera del rango 0-1), invierte su dirección (rebote).

Esta operación se paraleliza con @threads para mayor rendimiento.
"""
    function actualizar_posiciones!(bolas)
        @threads for i in eachindex(bolas)
            println("Pelotita $i actualizada por hilo $(Threads.threadid())")
            b = bolas[i]
            b.posicionX += b.velocidadX
            b.posicionY += b.velocidadY

            if b.posicionX < 0 || b.posicionX > 1
                b.velocidadX *= -1
            end
            if b.posicionY < 0 || b.posicionY > 1
                b.velocidadY *= -1
            end
        end
    end

"""
Genera un gráfico tipo scatter con la posición actual de las pelotitas dentro del espacio 2D (0,1).
El gráfico no tiene leyenda y usa color rojo por defecto.
"""

    function dibujar(bolas)
        x = [b.posicionX for b in bolas]
        y = [b.posicionY for b in bolas]
        scatter(x, y, xlim=(0,1), ylim=(0,1), legend=false, size=(400,400), title="Simulación de pelotitas", color=:red)
    end

"""
Simula el movimiento de 2 pelotitas dentro de una caja 2D durante 50 fotogramas.
Genera una animación y la guarda como archivo pelotitas.gif en el directorio actual.
"""

function simular_pelotitas()
    println(" Iniciando comparación: secuencial vs paralela con animación de pelotitas...\n")
    bolas = crear_bolas(2)  # pocas para que se vean mejor
    anim = @animate for _ in 1:50
        actualizar_posiciones!(bolas)
        dibujar(bolas)
        
    end

    println("\n Hilos disponibles: ", Threads.nthreads())

    # gif(anim, "pelotitas.gif", fps=20)
    mkpath("../Salidas")  # crea la carpeta si no existe
    gif(anim, "../Salidas/pelotitas.gif", fps=20)  # guarda el gif en la carpeta correcta

    println("\n Generando animación visual...")  
    println("GIF generado en: Salidas/pelotitas.gif")

    println("Número de hilos disponibles: ", Threads.nthreads())
    end
end
