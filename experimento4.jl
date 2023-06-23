

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