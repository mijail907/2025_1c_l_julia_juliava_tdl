module Pelotitas

    using Plots
    using Random
    using Base.Threads
    
    export simular_pelotitas

    mutable struct Ball
        x::Float64
        y::Float64
        vx::Float64
        vy::Float64
    end

    function crear_bolas(n)
        [Ball(rand(), rand(), randn() * 0.01, randn() * 0.01) for _ in 1:n]
    end

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

    function dibujar(bolas)
        x = [b.x for b in bolas]
        y = [b.y for b in bolas]
        scatter(x, y, xlim=(0,1), ylim=(0,1), legend=false, size=(400,400), title="Simulación de pelotitas")
    end

    

    function simular_pelotitas()
        bolas = crear_bolas(100)
        anim = @animate for _ in 1:200
            actualizar_posiciones!(bolas)
            dibujar(bolas)
        end
        gif(anim, "pelotitas.gif", fps=20)
    end

end # module
