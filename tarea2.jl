using Plots

#crecimiento estocástico con repique cada 50 (elimina 90%)
#código igual, reciclar entonces.
#bucle while para modelo continuo en general
#lambda tasa crecimiento
#N₀ población inicial, en general 1
# tfinal: tiempo en el cual termina la simulación
#trepique: tasa repique, donde se elimina la población
#h fracción de tiempo, si es 1 entonces es modelo discreto, si los pasos en el tiempo son fracciones, entonces es continuo
#pop vector con el número de la población en cada vuelta del ciclo
# i es el paso, e iterador, siempre decir que luego del ciclo se suma un paso

function crec_exp_rep(λ, N₀ ,tfinal,trepique,h)
    pop = [N₀] 
    ts= [0.0]
    i=1
    t=0.0
    while t<= tfinal 
        pop1=pop[i]+λ*h*pop[i] 
        t=ts[i]+h
        i+= 1
            if t % trepique <=0.0
                #eliminar el 90% de población 
                pop1 = 0.1* pop1
            end
        push!(pop,pop1)
        push!(ts,t)    

    end
    return ts, pop
   
end

cr1 = crec_exp_rep(0.0125,1.0,500.0,50.0,0.125)
plot(cr1)

#tiempo repique menor a uno, no hay repique
cr2 = crec_exp_rep(0.0125,1.0,500.0,0.10,0.125)
plot(cr2)

cr3 = crec_exp_rep(0.0125,1.0,500.0,0.10,0.125)
plot(cr3)

cr4 = crec_exp_rep(0.0125,1.0,500.0,10.0,0.125)
plot(cr4)

#tasa de crecimiento alta
#ante el primer evento de subida, hay repique, luego un crecimiento
#exoponencial abrupto y repique
cr5 = crec_exp_rep(0.6125,1.0,500.0,10.0,0.125)
plot(cr5)

#tasa crecimiento alta, numero e iteraciones mayor

cr6 = crec_exp_rep(0.005,1.0,500.0,50,0.75)
plot(cr6)


cr7 = crec_exp_rep(0.0075,1.0,500.0,50,0.75)
plot(cr7)

#conclusiones, tasaas de cecimientos bajas llevan a la extinción
# pasos de tiempos muy pequeños saturan el gráfico se van a x10^al la chingada

