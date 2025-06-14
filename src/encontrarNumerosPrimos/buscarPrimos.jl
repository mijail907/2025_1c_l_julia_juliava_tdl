module Primos

export encontrar_primos, es_primo

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
end # module