#
#Activar el proyecto de la carpeta actual
# usar ] luego 'activate .'
# administraor de paquetes ]


#Que paquetes se van a utilizar ?

#ejemplo 'add Plot'

#using Plots, me autoriza a utilizar el paquete

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
x = zeros[3,4]

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

#Realizando un vector de V o F, y sumando al vector vacío
eventos = Bool[]
for i in 1:100
    push!(eventos,evento_aleatorio(0.1))
end

#count(eventos)
###############################################
##ACTIVIDAD CAMINANTE ALEATORIO
#Hacer funcion caminante aleatorios
#Una funcion que diga si da un paso hacia adelante o hacia atras

function caminante_aleatorio(p)
    if rand() < p
        return @info "Paso atrás"
    else
        return @info "Paso adelante"
    end
end

caminante_aleatorio(0.125)

####
### Utilizamos evento_aleatorio, una función anterior !
function caminante_aleatorio(p,pasos)
    ev=Int8[]
        for i in 1:pasos
            if (evento_aleatorio(p))
                push!(ev, 1)
            else 
                push!(ev, -1)
            end
        end
    return ev 
end
eventos = caminante_aleatorio(0.5,100)

using Plots
plot(eventos)

scatter!(eventos)

########
## Función que calcule el crecimiento exponencial !
#usar barra \ lambda para hacer λ con tabulador
# en tiempo discreto

#N(t+h)= N(t)+lambda*N(t)

#deirle cuando terminar

function crec_exp(λ, N₀ ,tfinal)
    pop = [N₀] #pushear ! 
    for  t in 1: tfinal -1#guardar todos los resultados
        #menos 1 es un detalle para que de exacto 100 iteraciones
        pop1=pop[t]+λ*pop[t] #según la fórmula de crecimiento exponencial
        push!(pop,pop1)

    end
    return pop
   #con return "sale afuera"
end

p1=crec_exp(0.1 , 1.0 , 100)    

plot(p1)

p2=crec_exp(0.15 , 1.0 , 100)    
#para anidar uso !
plot!(p2)


p3=crec_exp(0.15 , 1.0 , 1000)    
plot!(p3)



#Hacerlo estocástico
#es decir aveces va a crecer y otras no

#tiempo que va a tardar en darse en un nacimiento

#ese tiempo tiene una distribución exponencial

#el tiempo a un evento con una tasa determinada

###


##Fin clase 1
###############