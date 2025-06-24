module Primos

export encontrar_primos, es_primo, encontrar_primos_parallel, test_paralelismo

"""
Devuelve una lista con todos los números primos en el rango `[desde, hasta]`.
"""

    function encontrar_primos(desde::Int, hasta::Int)
        primos = Int[]
        for n in desde:hasta
            if es_primo(n)
                push!(primos, n)
            end
        end
        return primos
    end

"""
Devuelve `true` si `n` es un número primo, `false` si no lo es.
"""

    function es_primo(n::Int)
        if n ≤ 1
            return false
        elseif n == 2
            return true
        elseif iseven(n)
            return false
        end
        for i in 3:2:isqrt(n)
            if n % i == 0
                return false
            end
        end
        return true
    end

"""
Busca primos en paralelo dividiendo el tramo en 2 y usando tareas 
"""

    function encontrar_primos_parallel(desde::Int, hasta::Int)
        medio = (desde + hasta) ÷ 2

        t1 = Threads.@spawn begin
            println("Hilo 1 buscando de $desde a $medio (Thread $(Threads.threadid()))")
            # sleep(0.5)
            encontrar_primos(desde, medio)
        end

        t2 = Threads.@spawn begin
            println("Hilo 2 buscando de $(medio+1) a $hasta (Thread $(Threads.threadid()))")
            # sleep(0.5)
            encontrar_primos(medio+1, hasta)
        end

        return sort(vcat(fetch(t1), fetch(t2)))
    end

    function test_paralelismo()
        println("Comparación entre Búsqueda secuencial vs Búsqueda paralela")

        desde = 1
        hasta = 20_000_000

        println("Búsqueda secuencial:")
        t1 = time()
        primos_seq = encontrar_primos(desde, hasta)
        tiempo_seq = time() - t1
        println(" Tiempo secuencial: $(round(tiempo_seq, digits=3)) segundos")

        println("\n Búsqueda paralela:")
        t2 = time()
        primos_par = encontrar_primos_parallel(desde, hasta)
        tiempo_par = time() - t2
        println(" Tiempo paralelo: $(round(tiempo_par, digits=3)) segundos")

        println("\n ¿Cantidad de números primos encontrados por igual? ", primos_seq == primos_par)
    end

end # module