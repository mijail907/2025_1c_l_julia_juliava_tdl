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
    tercio = (hasta - desde + 1) ÷ 3
    tramo1_ini = desde
    tramo1_fin = desde + tercio - 1

    tramo2_ini = tramo1_fin + 1
    tramo2_fin = tramo2_ini + tercio - 1

    tramo3_ini = tramo2_fin + 1
    tramo3_fin = hasta

    t1 = Threads.@spawn begin
        println("Hilo 1: $tramo1_ini a $tramo1_fin (Thread $(Threads.threadid()))")
        encontrar_primos(tramo1_ini, tramo1_fin)
    end

    t2 = Threads.@spawn begin
        println("Hilo 2: $tramo2_ini a $tramo2_fin (Thread $(Threads.threadid()))")
        encontrar_primos(tramo2_ini, tramo2_fin)
    end

    t3 = Threads.@spawn begin
        println("Hilo 3: $tramo3_ini a $tramo3_fin (Thread $(Threads.threadid()))")
        encontrar_primos(tramo3_ini, tramo3_fin)
    end

    return sort(vcat(fetch(t1), fetch(t2), fetch(t3)))
end

"""
Compara tiempos de ejecución entre versión secuencial y paralela.
"""
    function test_paralelismo()
        desde = 1
        hasta = 20_000_000

        println(" Búsqueda secuencial:")
        t1 = time()
        primos_seq = encontrar_primos(desde, hasta)
        tiempo_seq = time() - t1
        println(" Tiempo secuencial: $(round(tiempo_seq, digits=3)) segundos")

        println("\nBúsqueda paralela:")
        t2 = time()
        primos_par = encontrar_primos_parallel(desde, hasta)
        tiempo_par = time() - t2
        println("Tiempo paralelo: $(round(tiempo_par, digits=3)) segundos")

        println("\n¿Resultados iguales? ", primos_seq == primos_par)
    end
end # module