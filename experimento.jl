#
#Activar el proyecto de la carpeta actual
# usar ] luego 'activate .'
# administraor de paquetes ]


#Que paquetes se van a utilizar ?

#ejemplo 'add Plot'

#variables. Tipos de variables

x = 10 #variable tipo número entero
typeof(x) #que tipo de variable es ?

x = 10.0
typeof(x)

#shift enter ejecuta la linea

y = 10
x + y 

#vectores y matrices

#representan variables de estado o variables forzantes del modelo

x = [10 ,10,10,10,11]

#inicializar un vector de 10 elementos de tipo
#real con ceros
x = zeros(10)

#inicializar matriz
#tres filas cuatro columnas
x = zeros [3,4]

#puedo decirle que tipo de número uso
#le digo que cree vector vacia
x = [Float16]

mat =[10 11; 12 13]

x = ones[10]
#####

#Multiplicar escalares por vectores
#Toma la notación matemática

#operaciones no definidas para vectores
# se realizan utilizando un punto

x = 5 * x

log(x)

log.(x)


#condicionales

if length(x) == 1
    @info "El vector es de largo 1"
else
    @info "El vector es mayor que 1"
end

#elseif

if length(x) == 1
    @info "El vector es de largo 1"
elseif length(x) == 2
    @info "El vector es de lrgo 2"
else
    @info "El vector es mayor que 2"
end


#peso $ es una funcion que me permite evalur 
#funciones detro de caracteres

if typeof(x) == "vector"
    @info ""
else
    @info "el tipo x es $(typeof(x))"
end

#bucle
for i in 1:10
    @info "i = $(i)"
end

#bucle y condicionales

for i in 1:10
    if i == 5
        @info "OHHH ! i es igual a 5"
    else
        @info "i es igual a $(i)"
    end
end


# números aleatorios

x= rand(10)

for i in 1:10
    if x[i]<0.2
        @info "Evaluamos la probablidad de 0.2"
    end
end

p = 0.2
for i in 1:10
    if (rand() < p)
        @info "V"
    else 
        @info "False"
    end
end


#encapsular serie de comandos

#funciones

function evento_aleatorio(p)
    if rand() < p
        return true
    else
        return false
    end
end

evento_aleatorio(0.1)

#eventos = true
evento = Bool[]
typeof(evento)

push!(evento, false)

length(evento)

eventos = Bool[]
for i in 1:100
    push!(eventos,evento_aleatorio(0.1))
end

count(eventos)

#Hacer funcion caminante aleatorios
#Una funcion que diga si da un paso hacia adelante o hacia atras

function caminante_aleatoro(p)
    if rand() < p
        return @info "Paso atrás"
    else
        return @info "Paso adelante"
    end
end

ccaminante_aleatorio(0.6)aminante_aleatoro(0.15)
