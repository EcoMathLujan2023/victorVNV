
#Crecimiento exponencial determinístico discreto con intervalo de tiempo h variable

#Reciclo el código y digo que el tiempo es rand()

#intervalo de tiempo máximo será 50
#hₜ será el número de tiempo discreto máximo a evaluar

#utiliza findlast() para obtener el último valor del vector
#casos será el número de veces que pruebo el tiempo variable

function crec_exp(casos,λ, N₀, hₜ)
   for c in 1:casos - 1
    tam_pob=Float64[]

        tf=round(rand()*hₜ)
        tfinal=trunc(Int64, tf)
        pop = [N₀] #pushear ! 
        for  t in 1: tfinal #guardar todos los resultados
            #menos 1 es un detalle para que de exacto 100 iteraciones
            pop1=pop[t]+λ*pop[t] #según la fórmula de crecimiento exponencial
            push!(pop,pop1)

        end
        return pop
        push!(tam_pob,maximum(pop))
    #con return "sale afuera"
    return tam_pob
    end
end

mapa1=crec_exp(3.0,0.1 , 1.0 , 30.0)    

plot(mapa1)

mapa2=crec_exp(3.0,0.1 , 5.0 , 40.0)

plot!(mapa2)

mapa3=crec_exp(15.0,0.1 , 6.0 , 30.0)

plot!(mapa3)