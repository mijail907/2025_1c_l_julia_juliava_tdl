# 2025_1c_l_julia_juliava_tdl
Trabajo practico de la matería Teoría del lenguaje

Pasos para ejecutar el proyecto una vez clonado o descargado:

1- Posicionarse en la carpeta raíz del proyecto
2- En la terminar ejecutá los siguientes comandos:

# Instala los paquetes necesarios
    julia --project=. -e 'import Pkg; Pkg.instantiate()'

# Ejecuata el programa
    julia --project=. -t 3 src/main.jl