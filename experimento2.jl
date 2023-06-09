#Al utilizar doble corchetes
#realiza todo las lineas

##

using Plots

t=0.0
h=0.1
while t<= tfinal
    t= t + h
    @info t
    
end

##

#lamba tiempo de crecimiento en punto fijo
#lambada unidades 1/año
# h represent algo que multiplica es una fracción de tiempo
# 1/año * h

#si h es uno recupera la funcion discreta

#h podria representar el t en el cual se reproduce la población




function crec_exp(λ, N₀ ,tfinal,h=1.0)
    pop = [N₀] #pushear ! 
    ts= [0.0]
    #Para evaluar los tiempos sin iterar sobre este
   #inice que indica que elemento de la vector se guara la poblacion
    i=1
    t=0.0
    while t<= tfinal #for  t in 1: tfinal -1#guardar todos los resultados
        #el for trabaja con iteración no con continuo
        #menos 1 es un detalle para que de exacto 100 iteraciones
        pop1=pop[i]+λ*h*pop[i] #según la fórmula de crecimiento exponencial
        #equivalente a aproximar a una ecuación continua
        t=ts[i]+h
        
        #es necesario que se incremente el indice
        #sino evalua la funcion al infinito con el indice cero
        i += 1
        push!(pop,pop1)
        push!(ts,t)    

    end
    return ts, pop
   #con return "sale afuera"
end

c1 = crec_exp(0.1,1.0,100,1)

c2 = crec_exp(0.1,1.0,100,0.5)
c3 = crec_exp(0.1,1.0,100,0.1)
c4 = crec_exp(0.1,1.0,100,0.01)
c5 = crec_exp(0.1,1.0,100,0.00001)
plot(c1)

plot!(c2)

plot!(c3)

plot!(c4)

plot!(c5)


#mientras mas peueño sea e delta t = h, la ecuacion diferencial será mas exacta.

#hacer repiques, por ejemplo en poblacion de bacterias
#

function crec_exp_repique(λ, N₀ ,tfinal,h=1.0, trepique)
    pop = [N₀] #pushear ! 
    ts= [0.0]
    #Para evaluar los tiempos sin iterar sobre este
   #inice que indica que elemento de la vector se guara la poblacion
    i=1
    t=0.0
    while t<= tfinal #for  t in 1: tfinal -1#guardar todos los resultados
        #el for trabaja con iteración no con continuo
        #menos 1 es un detalle para que de exacto 100 iteraciones
        pop1=pop[i]+λ*h*pop[i] #según la fórmula de crecimiento exponencial
        #equivalente a aproximar a una ecuación continua
        t=ts[i]+h
            if t % trepique <=0.0
                #@info 
                pop1 = 0.1* pop1
            end
            
        #es necesario que se incremente el indice
        #sino evalua la funcion al infinito con el indice cero
        i += 1
        push!(pop,pop1)
        push!(ts,t)    

    end
    return ts, pop
   #con return "sale afuera"
end
