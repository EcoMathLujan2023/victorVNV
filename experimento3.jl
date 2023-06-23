#experimento3
using Plots
#crecimiento y muerte

#Método de Euler, aproximación de primer orden
#Poblaciones que crecen en tiempo discreto
#Esto es, dejan huevos y mueren y reaparecen.

#empaquetar parámetros, parámetros dentro de un valor

# par se carga entre corchetes
#como forma de tupla, son vectores invariantes

function nac_mue_det(par, N₀ ,tfinal, h)
    λ, μ = par
    pop = Float64[N₀] #Fuerza que sea un valor flotante
    ts= [0.0]
    i=1
    t=0.0               #variable auxiliar

    while t<= tfinal 
        pop1 =  pop[i] + h * (λ * pop[i] - μ * pop[i])
        
        t = ts[i] - h 
        pop1=pop[i]+ 1 
        i+= 1
          
        push!(pop,pop1)
        push!(ts,t)    

    end
    return pop, ts
end

u1 = nac_mue_det([0.2,0.1],100.0,100.0,0.01)

function nac_mue_sto(par, N₀ ,tfinal)
    λ, μ = par
    pop = Float16[N₀] 
    ts= [0.0]
    i=1
    t=0.0               #variable auxiliar

    while t<= tfinal 
        B= pop[i]*λ  #tasa nacimiento poblacion
        M = pop[i]*μ
        R = B + M # tasa total de eventos

        t = ts[i] - log(rand())/R #tiempo a un evento a tasa R sucede una vez o un nacimiento o muerte
        #proximo tiempo. Aqui sucede un solo evento, la poblacion aumenta en 1
        #que evento sucede, decidir cual es el evento que sucede
        if rand() < B/R # evaluar la probabilidad, el evento sucede cuando el evento es probable dentro de su ratio de probabilidad
            pop1 = pop[i] + 1
        else
            pop1 = pop[i] - 1
        end

        #pop1=pop[i]+ 1 
        #poblacion mas grande, tiempo entre eventos es menor
        i+= 1
            
        push!(pop,pop1)
        push!(ts,t)    

    end
    return pop, ts
   
end

u2 = nac_mue_sto([0.2,0.3],100.0,100.0)

plot(u1)
plot!(u2)

