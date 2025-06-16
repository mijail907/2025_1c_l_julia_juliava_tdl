module Pelotitas

    using Plots
    using Random
    using Base.Threads
    using Dates
    
    export simular_pelotitas

"""
struct Ball

Representa una pelotita con posición (x, y) y velocidad (vx, vy) en un espacio 2D.
"""

    mutable struct Ball
        x::Float64 #Posición horizontal (eje X) de la pelotita (entre 0 y 1)
        y::Float64 #Posición vertical (eje Y) de la pelotita (entre 0 y 1)
        vx::Float64 #Velocidad horizontal (qué tanto se mueve en X por frame)
        vy::Float64 #Velocidad vertical (qué tanto se mueve en Y por frame)
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
Si una pelotita choca contra un borde (x o y fuera del rango 0-1), invierte su dirección (rebote).

Esta operación se paraleliza con @threads para mayor rendimiento.
"""
    function actualizar_posiciones!(bolas)
        @threads for i  in eachindex(bolas)
            println("Pelotita $i actualizada por hilo $(Threads.threadid())")
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

function actualizar_posiciones_serial!(bolas)
    for i in eachindex(bolas)
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
        # bolas = crear_bolas(2)
        # anim = @animate for _ in 1:50
        #     actualizar_posiciones!(bolas)
        #     dibujar(bolas)
        # end
        # gif(anim, "pelotitas.gif", fps=20)
              # por si no está incluido afuera

    println(" Iniciando comparación: secuencial vs paralela con animación de pelotitas...\n")

    # Crear pelotitas
    bolas_seq = crear_bolas(2)
    bolas_par = deepcopy(bolas_seq)  # para comparación justa

    # Medir tiempo secuencial
    println(" Actualización secuencial:")
    t1 = now()
    actualizar_posiciones_serial!(bolas_seq)
    println(" Tiempo secuencial: ", now() - t1)

    # Medir tiempo paralela
    println("\n Actualización paralela con @threads:")
    t2 = now()
    actualizar_posiciones!(bolas_par)
    println(" Tiempo paralela: ", now() - t2)

    println("\n Hilos disponibles: ", Threads.nthreads())

    # ANIMACIÓN FINAL (para visualización con pocas pelotitas)
    bolas = crear_bolas(2)  # pocas para que se vean mejor
    anim = @animate for _ in 1:50
        actualizar_posiciones!(bolas)
        dibujar(bolas)
    end

    println("\n Generando animación visual...")
    
        

    println("\n Hilos disponibles: ", Threads.nthreads())
        
    println("GIF generado: pelotitas.gif")
    println("Número de hilos disponibles: ", Threads.nthreads())
    end
end
