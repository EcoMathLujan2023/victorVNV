


"""
    ECUACIONES modelo RED SUELO

    Enfoque de grandes grupos 
    Para simplificar las interacciones: HOJARASCA - MICROFLORA (descomponedores) - MESOFAUNA (microfitofagos - predadores)
    MICROFAUNA (microfitofagos - predadores)
        
    ### ACTORES NODOS DE LA RED DE SUELOS

        H = hojarasca
        microflora = son hongos y bacterias descomponedoras de la materia orgánica, osea, hojarasca
        MICROFAUNA_d = microfauna microfitofaga
        MICROFAUNA_p = microfauna predadora
        MESOFAUNA_d = mesofauna microfitofaga
        MESOFAUNA_p = microfauna predadora
        MACRO_d = macrofauna detritivora
        MACRO_p = macrofauna predadora
        

    ### COEFICIENTES 
        a = ingreso hojarasca
        d = desaparición fisica quimica natural de la hojarasca

        b = crecimiento microflora
        c = crecimiento MICROFAUNA_d
        g = crecimiento MESOFAUNA_d
        j = crecimiento MACRO_d
        
        mmp = muerte microfauna predadora
        mmep = muerte mesofauna predadora
        mmacp = muerte de la macrofauna predadora

        e = eficiencia descomposición de hojarasca por parte de la microflora
        f = eficiencia de asimilación de la microflora que se alimenta de hojarasca
        
        i = eficiencia de asimilación de la MICROFAUNA_d que come Microflora
        k = eficiencia asimilacion MICROFAUNA_p que come MICROFAUNA_d
        q = eficiencia asimilacion MESOFAUNA_d que come Microflora

        l1 = eficiencia asimilacion MESOFAUNA_p que come micro detritivora
        l2 = eficiencia asimilacion MESOFAUNA_p que come micro predadora
        l3 = eficiencia asimilacion MESOFAUNA_p que come meso detritivora

        n1 = eficiencia de asimilación de la MACRO_p que come MESOFAUNA_d
        n2 = eficiencia de asimilación de la MACRO_p que come MESOFAUNA_p
        n3 = eficiencia de asimilación de la MACRO_p que come MACRO_d
        

        ea = eficiencia asimilacion microflora
        edm = eficiencia descomposición de hojarasca por parte de la macrofauna
        eam1 = eficiencia asimilacion de la MACRO_d que come hojarasca
        eam2 = eficiencia asimilacion de la MACRO_d que come microflora

        
    ### ECUACIONES según modelos de Lotka-Volterra

        #Hojarasca: posee ingreso, consumo de microflora, consumo de macrofauna y descomposición
    δH = a - H*microflora*e - MACRO_d*edm - d*H

        #Microflora: tasa crecimiento, crecimiento por alimentarse, deaparicion por microfauna, mesofauna y macrofauna
    
    δMicroflora = b*Microflora + H*Microflora*f - MICROFAUNA_d*Microflora - MESOFAUNA_d*Microflora - MACRO_d*Microflora

        #Microfauna microfitofaga: crece a una tasa, crece por lo asimilado al alimentarse por microflora
        # desaparece por la predación de microfauna predadora y mesofauna predadora 

    δMICROFAUNA_d = c*MICROFAUNA_d + i*MICROFAUNA_d*Microflora - MESOFAUNA_p*MICROFAUNA_d - MICROFAUNA_p*MICROFAUNA_d
    
        #Microfauna predadora, crece debido a su alimentacion de microfauna microfitófaga
        # y desaparece por la predación por parte de la mesofauna predadora y una tasa de muerte

    δMICROFAUNA_p = k*MICROFAUNA_p*MICROFAUNA_d - mmp*MICROFAUNA_p - MESOFAUNA_p*MICROFAUNA_p
    
        #Mesofauna microfitófaga: tiene una tasa de crecimiento propio, sumada a la asimilación al alimentarse de microflora
        #desaparece debido a la predación sufrida por mesofauna y macrofauna predadora

    δMESOFAUNA_d = g*MESOFAUNA_d + q*MESOFAUNA_d*microflora - MESOFAUNA_p*MESOFAUNA_d - MACRO_p*MESOFAUNA_d 
    
        #Mesofauna predadora: desaparece por una tasa de muerte y por la predación por parte de la Macrofauna predadora
        #crece por alimentarse de microfauna microfitofaga y predadora y de mesofauna microfitófaga

    δMESOFAUNA_p = - mmep*MESOFAUNA_p - MACRO_p*MESOFAUNA_p + l1*MESOFAUNA_p*MICROFAUNA_d + l2*MESOFAUNA_p*MICROFAUNA_p + l3*MESOFAUNA_p*MESOFAUNA_d
    
        #MAcrofauna crece por tasa de crecimiento, y por alimentarse de Hojarasca y de Microflora

    δMACRO_d = j*MACRO_d + MACRO_d*eam1*H + MACRO_d*eam2*Microflora - MACRO_d * MACRO_p

        #Macrofauna predadora se alimenta de Mesofauna microfitofaga y predadora y de macrofauna detritivora
        # desaparece por una tasa de muerte

    δMACRO_p = n1*MESOFAUNA_d*MACRO_p + MESOFAUNA_p*MACRO_p*n2 + MACRO_d*MACRO_p*n3 - mmacp*MACRO_p

    
"""


#INTENTANDO IMPLEMENTAR UN GRAFO QUE MUESTRE LAS INTERACCIONES
"""
using LightGraphs
using GraphPlot
using NetworkLayout
using Plots


# Crear un grafo simple con nodos etiquetados
red_suelo = SimpleGraph(8)
nombres_nodos = Dict(
    "hojarasca" => 1,
    "microflora" => 2,
    "ma-fauna_microfitofaga" => 3,
    "mi-fauna_microfitofaga" => 4,
    "me-fauna_microfitofaga" => 5,
    "mi-fauna_predadora" => 6,
    "me-fauna_predadora" => 7,
    "ma-fauna_predadora" => 8
)
add_edge!(red_suelo, nombres_nodos["microflora"], nombres_nodos["hojarasca"])
add_edge!(red_suelo, nombres_nodos["ma-fauna_microfitofaga"], nombres_nodos["hojarasca"])
add_edge!(red_suelo, nombres_nodos["mi-fauna_microfitofaga"], nombres_nodos["microflora"])
add_edge!(red_suelo, nombres_nodos["me-fauna_microfitofaga"], nombres_nodos["microflora"])
add_edge!(red_suelo, nombres_nodos["ma-fauna_microfitofaga"], nombres_nodos["microflora"])
add_edge!(red_suelo, nombres_nodos["mi-fauna_predadora"], nombres_nodos["mi-fauna_microfitofaga"])
add_edge!(red_suelo, nombres_nodos["me-fauna_predadora"], nombres_nodos["mi-fauna_predadora"])
add_edge!(red_suelo, nombres_nodos["me-fauna_predadora"], nombres_nodos["me-fauna_microfitofaga"]) 
add_edge!(red_suelo, nombres_nodos["ma-fauna_predadora"], nombres_nodos["me-fauna_microfitofaga"]) 
add_edge!(red_suelo, nombres_nodos["ma-fauna_predadora"], nombres_nodos["me-fauna_predadora"]) 
# Visualizar el grafo en un diseño de red (network layout)
layout = fruchterman_reingold_layout(red_suelo)
gplot(red_suelo,  nodelabel = 1:8, nodelabels = values(nombres_nodos))

"""

using DifferentialEquations
using Plots

function lotka_volterra!(du, u, p, t)
    H, microflora, MICROFAUNA_d, MICROFAUNA_p, MESOFAUNA_d, MESOFAUNA_p, MACRO_d, MACRO_p = u
    a, d, b, c, g, j, mmp, mmep, mmacp, e, f, i, k, q, l1, l2, l3, n1, n2, n3, ea, edm, eam1, eam2 = p
    
    du[1] = a - H * microflora * e - MACRO_d * edm - d * H
    du[2] = b * microflora + H * microflora * f - MICROFAUNA_d * microflora - MESOFAUNA_d * microflora - MACRO_d * microflora
    du[3] = c * MICROFAUNA_d + i * MICROFAUNA_d * microflora - MESOFAUNA_p * MICROFAUNA_d - MICROFAUNA_p * MICROFAUNA_d
    du[4] = k * MICROFAUNA_p * MICROFAUNA_d - mmp * MICROFAUNA_p - MESOFAUNA_p * MICROFAUNA_p
    du[5] = g * MESOFAUNA_d + q * MESOFAUNA_d * microflora - MESOFAUNA_p * MESOFAUNA_d - MACRO_p * MESOFAUNA_d
    du[6] = - mmep * MESOFAUNA_p - MACRO_p * MESOFAUNA_p + l1 * MESOFAUNA_p * MICROFAUNA_d + l2 * MESOFAUNA_p * MICROFAUNA_p + l3 * MESOFAUNA_p * MESOFAUNA_d
    du[7] = j * MACRO_d + MACRO_d * eam1 * H + MACRO_d * eam2 * microflora - MACRO_d * MACRO_p
    du[8] = n1 * MESOFAUNA_d * MACRO_p + MESOFAUNA_p * MACRO_p * n2 + MACRO_d * MACRO_p * n3 - mmacp * MACRO_p
end

# Condiciones iniciales
u0 = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]

# Coeficientes y parámetros
p = [a, d, b, c, g, j, mmp, mmep, mmacp, e, f, i, k, q, l1, l2, l3, n1, n2, n3, ea, edm, eam1, eam2]

# Rango de tiempo
tspan = (0.0, 10.0)

# Resolver las ecuaciones diferenciales
prob = ODEProblem(lotka_volterra!, u0, tspan, p)
sol = solve(prob, Tsit5(), saveat=0.1)

# Graficar los resultados
plot(sol, title="Dinámica de la Red de Interacciones", xlabel="Tiempo", ylabel="Población", label=["H" "microflora" "MICROFAUNA_d" "MICROFAUNA_p" "MESOFAUNA_d" "MESOFAUNA_p" "MACRO_d" "MACRO_p"])
