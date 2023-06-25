

using Plots

# N = Nutrientes
# P = Población (fitoplankton)
#
# dN = a - b N P - e N
# dP = c N P - d P 
#
# a = Tasa de ingreso de Nutrientes
# b = Consuma de Nutrientes por la poblacion P
# e = Tasa de degradacion de Nutrientes
#
# c = Tasa de asimilación c < b
# d = Mortalidad de la poblacion

function logistico_det(par,pob, tfinal, h=1.0)    # asume intervalo de tiempo = h
    a, b, c, d, e = par  
    N₀,P₀ = pob       # desempaquetamos los parámetros
    popP = Float64[N₀]
    popN = Float64[N₀]                        # Forzamos variable a Float64 (numero real)
    ts  = [0.0]
    i = 1
    t = 0.0
    #@info "Pop[1] $(pop[i]) indice $(i)"

    while t <= tfinal
        popN1 = popN[i] + h * ( a - b*popN[i]*popP[i]- e*popN[i]) 
        popP1 = popN[i] + h * ( c *popN[i]*popP[i]- d*popP[i]) 
        
        #@info "Pop1 $(pop1) indice $(i)"
        t = ts[i] + h
        i += 1                   # equivale a i = i + 1 
        push!(popN, popN1)
        push!(popP, popP1)
        push!(ts,t)
    end
    return ts,popN, popP
end

t, N, P=logistico_det([0.2,0.8,0.3,0.02,0.5],[100,80], 1000, 0.001)
plot(N,P)
plot(t,N)
plot!(t,P)


#
# Ejercicio
#
# 1) Igualar a cero las ecuaciones para sacar de 
# forma analitica los puntos de equilibrio

#
# dN = a - b N P - e N
# dP = c N P - d P 
# si dN = dP  => c N P - d P = a - b N P - e N
#                c N P - d P  +   a - b N P - e N = 0
##LAPIZ####
#                (c-b)NP+a-dP-eN=0
# 2) Hacer un grafico de bifurcaciones
#
# 3) Hacer la versión estocástica
#

#La versión estocástica Debe ser Tener un Nac y Muerte para cada ecuación y ahí suma a la pop
#Osea R = N1 N2 M1 M2

function logistico_det(par,pob, tfinal, h=1.0)    # asume intervalo de tiempo = h
    a, b, c, d, e = par  
    N₀,P₀ = pob       # desempaquetamos los parámetros
    popP = Float64[N₀]
    popN = Float64[N₀]                        # Forzamos variable a Float64 (numero real)
    ts  = [0.0]
    i = 1
    t = 0.0
    #@info "Pop[1] $(pop[i]) indice $(i)"

    while t <= tfinal
        popN1 = popN[i] + h * ( a - b*popN[i]*popP[i]- e*popN[i]) 
        popP1 = popN[i] + h * ( c *popN[i]*popP[i]- d*popP[i]) 
        
        #@info "Pop1 $(pop1) indice $(i)"
        t = ts[i] + h
        i += 1                   # equivale a i = i + 1 
        push!(popN, popN1)
        push!(popP, popP1)
        push!(ts,t)
    end
    return ts,popN, popP
end

function interaccion_poblacionales_sto(par,pob,tfinal)    
    a, b, c, d, e = par  
    N₀,P₀ = pob       # desempaquetamos los parámetros
    popP = Float64[P₀]
    popN = Float64[N₀]                        # Forzamos variable a Float64 (numero real)
    ts  = [0.0]
    i = 1
    t = 0.0
    while t <= tfinal
        #@info "Tiempo $(t) indice $(i)"

        B = popN[i] * a 
        M = popN[i]*popN[i]*(b + e)
        R = B + M 
        N = popP[i] *c
        M_p = popP[i]*popP[i]*d
        Q = N + M_p 

        t = ts[i] - log(rand()) / (R+Q)
        if rand() < B/R                   # probabilidad de nacimiento 
            popN = popN[i] + 1
        else
            popN = popN[i] - 1
        end
        if popN<= 0.0
            popN = 0.0 
        end
        if rand() < B/R                   # probabilidad de nacimiento 
            popP = popP[i] + 1
        else
            popP = popP[i] - 1
        end
        if popP<= 0.0
            popP = 0.0 
        end
        i += 1                  
        
    end
    return ts,popN, popP
end

t, N, P=interaccion_poblacionales_sto([0.2,0.8,0.3,0.02,0.5],[100,80], 1000)

