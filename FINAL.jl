
#INTENTANDO IMPLEMENTAR UN GRAFO QUE MUESTRE LAS INTERACCIONES

using Graphs, GraphRecipes, Plots


# Crear un grafo simple con nodos etiquetados
red_suelo = DiGraph()
add_vertices!(red_suelo,8)
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

etiqueta=["hojarasca",
"microflora",
"macro_microfitofaga",
"microfauna_microfitofaga",
"meso_microfitofaga",
"microfauna_predadora",
"meso_predadora",
"macro_predadora"]

function viewgraph(g)
    graphplot(g,
        # nodes
        #names= 1:nv(g),
        names = etiqueta,#1:nv(g)], #número vertices
        fontsize = 8,
        nodeshape = :circle,
        markersize = 0.015,
        markerstrokewidth = 2,
        # edges
        #edgelabel = edgelabels,
        linewidth = 2,
        curves = false
    )
end

red_suelo = viewgraph(red_suelo)


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

using DifferentialEquations
using Plots

#Discreta, pero me olvide de que existen interacciones de consumo, solo tiene de eficiencia
# Sin factores de consumo, es decir siempre que se da un encuentro de comen ¿


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
# gr/m²: H, microflora, MICROFAUNA_d, MICROFAUNA_p, MESOFAUNA_d, MESOFAUNA_p, MACRO_d, MACRO_p

u0 = [200, 105, 80, 60, 30, 50, 45, 25]

# Coeficientes y parámetros

#a = ingreso hojarasca; d = desaparición fisica quimica natural de la hojarasca
#b = crecimiento microflora; c = crecimiento MICROFAUNA_d ;g = crecimiento MESOFAUNA_d;j = crecimiento MACRO_d

#mmp = muerte microfauna predadora; mmep = muerte mesofauna predadora; mmacp = muerte de la macrofauna predadora

#e = eficiencia descomposición de hojarasca por parte de la microflora; f = eficiencia de asimilación de la microflora que se alimenta de hojarasca

#i = eficiencia de asimilación de la MICROFAUNA_d que come Microflora;k = eficiencia asimilacion MICROFAUNA_p que come MICROFAUNA_d
#q = eficiencia asimilacion MESOFAUNA_d que come Microflora

#l1 = eficiencia asimilacion MESOFAUNA_p que come micro detritivora; l2 = eficiencia asimilacion MESOFAUNA_p que come micro predadora
#l3 = eficiencia asimilacion MESOFAUNA_p que come meso detritivora

#n1 = eficiencia de asimilación de la MACRO_p que come MESOFAUNA_d ;n2 = eficiencia de asimilación de la MACRO_p que come MESOFAUNA_p
#n3 = eficiencia de asimilación de la MACRO_p que come MACRO_d


#ea = eficiencia asimilacion microflora
#edm = eficiencia descomposición de hojarasca por parte de la macrofauna
#eam1 = eficiencia asimilacion de la MACRO_d que come hojarasca
#eam2 = eficiencia asimilacion de la MACRO_d que come microflora


#p = [a, d, b, c, g, j, mmp, mmep, mmacp, e, f, i, k, q, l1, l2, l3, n1, n2, n3, ea, edm, eam1, eam2]
p = [50, 5, 50, 30, 12, 4, 40, 25, 6, 0.5, 0.7, 0.65,
     0.8, 0.6, 0.8, 0.75, 0.67, 0.7, 0.67, 0.6, 0.8, 0.4, 0.6, 0.7]

# Rango de tiempo
tspan = (0.0, 50.0)

# Resolver las ecuaciones diferenciales
prob = ODEProblem(lotka_volterra!, u0, tspan, p)
sol = solve(prob, Tsit5(), saveat=0.1)

# Graficar los resultados
plot(sol, title="Dinámica de la Red de Interacciones", 
    xlabel="Tiempo", ylabel="Población", 
    label=["H", "microflora", "MICROFAUNA_d", "MICROFAUNA_p", "MESOFAUNA_d", "MESOFAUNA_p",
     "MACRO_d", "MACRO_p"])



#La gráfica muestra los crecimientos poblacionales de forma determinística

using DifferentialEquations
using Plots

#Deterministica?
#VERSION con CONSUMO

function lotka_volterra1!(du, u, p, t)
    H, microflora, MICROFAUNA_d, MICROFAUNA_p, MESOFAUNA_d, MESOFAUNA_p, MACRO_d, MACRO_p = u
    a, d, b, c, g, j, mmp, mmep, mmacp,
    e, f, i, k, q, l1, l2, l3, n1, n2, n3, ea, edm, eam1, eam2,
    cn1, cn2, cn3, cn4, cn5, cn6, cn7, cn8, cn9, cn10 = p

    du[1] = a - H * microflora * e - MACRO_d * edm - d * H
    du[2] = b * microflora + H * microflora * f - MICROFAUNA_d * microflora * cn1 - MESOFAUNA_d * microflora * cn2 - MACRO_d * microflora*cn3
    du[3] = c * MICROFAUNA_d + i * MICROFAUNA_d * microflora - MESOFAUNA_p * MICROFAUNA_d*cn4 - MICROFAUNA_p * MICROFAUNA_d*cn5
    du[4] = k * MICROFAUNA_p * MICROFAUNA_d - mmp * MICROFAUNA_p - MESOFAUNA_p * MICROFAUNA_p*cn6
    du[5] = g * MESOFAUNA_d + q * MESOFAUNA_d * microflora - MESOFAUNA_p * MESOFAUNA_d*cn7 - MACRO_p * MESOFAUNA_d*cn8
    du[6] = - mmep * MESOFAUNA_p - MACRO_p * MESOFAUNA_p*cn9 + l1 * MESOFAUNA_p * MICROFAUNA_d + l2 * MESOFAUNA_p * MICROFAUNA_p + l3 * MESOFAUNA_p * MESOFAUNA_d
    du[7] = j * MACRO_d + MACRO_d * eam1 * H + MACRO_d * eam2 * microflora - MACRO_d * MACRO_p*cn10
    du[8] = n1 * MESOFAUNA_d * MACRO_p + MESOFAUNA_p * MACRO_p * n2 + MACRO_d * MACRO_p * n3 - mmacp * MACRO_p
end

# Condiciones iniciales
# gr/m²: H, microflora, MICROFAUNA_d, MICROFAUNA_p, MESOFAUNA_d, MESOFAUNA_p, MACRO_d, MACRO_p

u0 = [200, 105, 90, 85, 60, 50, 70, 40]

# Coeficientes y parámetros

#a = ingreso hojarasca; d = desaparición fisica quimica natural de la hojarasca
#b = crecimiento microflora; c = crecimiento MICROFAUNA_d ;g = crecimiento MESOFAUNA_d;j = crecimiento MACRO_d

#mmp = muerte microfauna predadora; mmep = muerte mesofauna predadora; mmacp = muerte de la macrofauna predadora

#e = eficiencia descomposición de hojarasca por parte de la microflora; f = eficiencia de asimilación de la microflora que se alimenta de hojarasca

#i = eficiencia de asimilación de la MICROFAUNA_d que come Microflora;k = eficiencia asimilacion MICROFAUNA_p que come MICROFAUNA_d
#q = eficiencia asimilacion MESOFAUNA_d que come Microflora

#l1 = eficiencia asimilacion MESOFAUNA_p que come micro detritivora; l2 = eficiencia asimilacion MESOFAUNA_p que come micro predadora
#l3 = eficiencia asimilacion MESOFAUNA_p que come meso detritivora

#n1 = eficiencia de asimilación de la MACRO_p que come MESOFAUNA_d ;n2 = eficiencia de asimilación de la MACRO_p que come MESOFAUNA_p
#n3 = eficiencia de asimilación de la MACRO_p que come MACRO_d


#ea = eficiencia asimilacion microflora
#edm = eficiencia descomposición de hojarasca por parte de la macrofauna
#eam1 = eficiencia asimilacion de la MACRO_d que come hojarasca
#eam2 = eficiencia asimilacion de la MACRO_d que come microflora

#cn1 consumo microf_det que comen microflora cn2 cons mesof_det que come microflora cn3 cons macro det
# cn4 cons mesop a microfaunad y cn5 micrfauna p a d
#cn6 consumo de mesofauna p a microfauna p
#cn7 consumo de meso predadoaa a detritivora cn8 consumo de macro pred a meso detritivora
#cn9 consumo macro predadora que come meso predadora
#cn10 macro predadora que come macro detritivora




#p = [a, d, b, c, g, j, mmp, mmep, mmacp, e, f, i, k, q, l1, l2, l3, n1, n2, n3, ea, edm, eam1, eam2,
#     cn1,cn2,cn3,cn4,cn5,cn6,cn7,cn8,cn9,cn10]
p = [50, 10, 50, 30, 12, 4, 40, 25, 6, 0.5, 0.7, 0.65, 0.8, 0.6, 0.8, 0.75, 0.67, 0.7, 0.67, 0.6, 0.8, 0.4, 0.6, 0.7,
     0.7,0.65,0.4,0.6,0.7,0.7,0.7,0.4,0.5,0.6]

# Rango de tiempo
tspan = (0.0, 50.0)

# Resolver las ecuaciones diferenciales
prob = ODEProblem(lotka_volterra1!, u0, tspan, p)
sol1 = solve(prob, Tsit5(), saveat=0.1)

# Graficar los resultados
plot(sol1, title="Dinámica de la Red de Interacciones", xlabel="Tiempo", ylabel="Población", label=["H" "microflora" "MICROFAUNA_d" "MICROFAUNA_p" "MESOFAUNA_d" "MESOFAUNA_p" "MACRO_d" "MACRO_p"])

#La gráfica muestra los crecimientos poblacionales de forma determinística

#Estocástica ?

function lotka_stoc(p, u, tfinal)
    H1, microflora1, MICROFAUNA_d1, MICROFAUNA_p1, MESOFAUNA_d1, MESOFAUNA_p1, MACRO_d1, MACRO_p1 = u #valores iniciales
    a, d, b, c, g, j, mmp, mmep, mmacp,
    e, f, i, k, q, l1, l2, l3, n1, n2, n3, ea, edm, eam1, eam2,
    cn1, cn2, cn3, cn4, cn5, cn6, cn7, cn8, cn9, cn10 = p # desempaquetamos los parámetros

   H = Float64[H1]
   microflora = Float64[microflora1]
   MICROFAUNA_d = Float64[MICROFAUNA_d1]
   MICROFAUNA_p = Float64[MICROFAUNA_p1]
   MESOFAUNA_d = Float64[MESOFAUNA_d1]
   MESOFAUNA_p = Float64[MESOFAUNA_p1]
   MACRO_d = Float64[MACRO_d1]
   MACRO_p = Float64[MACRO_p1]

   # a , b , e, c, d  = par                       # desempaquetamos los parámetros
   # N1,P1  = ini                                 # desempaquetamos los valores iniciales
   # N = Float64[N1]                              # Forzamos variable a Float64 (numero real)
   # P = Float64[P1]

    ts  = [0.0]
    i = 1
    t = 0.0
    while t <= tfinal
        #@info "Tiempo $(t) indice $(i)"
        #nacimiento subfijo b y muerte subfijo d

        Hb = a

        Hd = H[i] * microflora[i] * e + MACRO_d[i] * edm + d * H[i]

        microflorab = b * microflora[i] + H[i] * microflora[i] * f
        microflorad =  MICROFAUNA_d[i]* microflora[i]*cn1 + MESOFAUNA_d[i] * microflora[i]*cn2 + MACRO_d[i] * microflora[i]*cn3

        MICROFAUNA_db= c * MICROFAUNA_d[i] + i * MICROFAUNA_d[i] * microflora[i]
        MICROFAUNA_dd= MESOFAUNA_p[i] * MICROFAUNA_d[i]*cn4 + MICROFAUNA_p[i] * MICROFAUNA_d[i]*cn5

        MICROFAUNA_pb = k * MICROFAUNA_p[i] * MICROFAUNA_d[i]
        MICROFAUNA_pd = mmp * MICROFAUNA_p[i] + MESOFAUNA_p[i] * MICROFAUNA_p[i] *cn6

        MESOFAUNA_db = g * MESOFAUNA_d[i] + q * MESOFAUNA_d[i] * microflora[i]
        MESOFAUNA_dd = MESOFAUNA_p[i] * MESOFAUNA_d[i]*cn7 + MACRO_p[i] * MESOFAUNA_d[i]*cn8

        MESOFAUNA_pb= l1 * MESOFAUNA_p[i] * MICROFAUNA_d[i] + l2 * MESOFAUNA_p[i] * MICROFAUNA_p[i] + l3 * MESOFAUNA_p[i] * MESOFAUNA_d[i]
        MESOFAUNA_pd= mmep * MESOFAUNA_p[i] + MACRO_p[i] * MESOFAUNA_p[i] * cn9

        MACRO_db = j * MACRO_d[i] + MACRO_d[i] * eam1 * H[i] + MACRO_d[i] * eam2 * microflora[i]
        MACRO_dd = MACRO_d[i] * MACRO_p[i]*cn10

        MACRO_pb = n1 * MESOFAUNA_d[i] * MACRO_p[i] + MESOFAUNA_p[i] * MACRO_p[i] * n2 + MACRO_d[i] * MACRO_p[i] * n3
        MACRO_pd = mmacp * MACRO_p[i]

        R = Hb + Hd + microflorab + microflorad + MICROFAUNA_db + MICROFAUNA_dd + MICROFAUNA_pb +
            MICROFAUNA_pd + MESOFAUNA_db + MESOFAUNA_dd + MESOFAUNA_pb + MESOFAUNA_pd +
            MACRO_db + MACRO_dd + MACRO_pb + MACRO_pd

        # Distribución exponencial
        t = ts[i] - log(rand()) / R


        #genera un valor aleatorio y ve a que rango se ajusta
        rnd = rand()

        #Probabilidad de que se rompa ALTAS

        if rnd < Hb/R                     # probabilidad de nacimiento
            H1 = H[i] + 1
        elseif rnd < (Hb + Hd)/ R
            H1 = H[i] - 1

        elseif rnd <  (Hb + Hd + microflorab)/ R
            microflora1 = microflora[i] + 1
        elseif rnd <  (Hb + Hd + microflorab + microflorad)/ R
            microflora1 = microflora[i] - 1

        elseif rnd <  (Hb + Hd + microflorab+microflorad + MICROFAUNA_db)/ R
            MICROFAUNA_d1 = MICROFAUNA_d[i] + 1
        elseif rnd <  (Hb + Hd + microflorab + microflorad + MICROFAUNA_db + MICROFAUNA_dd )/ R
            MICROFAUNA_d1 = MICROFAUNA_d[i] - 1

        elseif rnd <  (Hb + Hd + microflorab + microflorad + MICROFAUNA_db + MICROFAUNA_dd + MICROFAUNA_pb)/ R
            MICROFAUNA_p1 = MICROFAUNA_p[i] + 1
        elseif rnd <  (Hb + Hd + microflorab + microflorad + MICROFAUNA_db + MICROFAUNA_dd + MICROFAUNA_pb + MICROFAUNA_pd )/ R
            MICROFAUNA_p1 = MICROFAUNA_p[i] - 1

        elseif rnd <  (Hb + Hd + microflorab + microflorad + MICROFAUNA_db + MICROFAUNA_dd + MICROFAUNA_pb +
                        MICROFAUNA_pd + MESOFAUNA_db )/ R
            MESOFAUNA_d1 = MESOFAUNA_d[i] + 1
        elseif rnd <  (Hb + Hd + microflorab + microflorad + MICROFAUNA_db + MICROFAUNA_dd + MICROFAUNA_pb + MICROFAUNA_pd+
                        MESOFAUNA_db + MESOFAUNA_dd)/ R
            MESOFAUNA_d1 = MESOFAUNA_d[i] - 1

        elseif rnd <  (Hb + Hd + microflorab + microflorad + MICROFAUNA_db + MICROFAUNA_dd + MICROFAUNA_pb +
                        MICROFAUNA_pd + MESOFAUNA_db + MESOFAUNA_dd + MESOFAUNA_pb )/ R
            MESOFAUNA_p1 = MESOFAUNA_p[i] + 1
        elseif rnd <  (Hb + Hd + microflorab + microflorad + MICROFAUNA_db + MICROFAUNA_dd + MICROFAUNA_pb + MICROFAUNA_pd+
                        MESOFAUNA_db + MESOFAUNA_dd + MESOFAUNA_pd)/ R
            MESOFAUNA_p1 = MESOFAUNA_p[i] - 1

        elseif rnd <  (Hb + Hd + microflorab + microflorad + MICROFAUNA_db + MICROFAUNA_dd + MICROFAUNA_pb +
                        MICROFAUNA_pd + MESOFAUNA_db + MESOFAUNA_dd + MESOFAUNA_pb + MESOFAUNA_pd + MACRO_db )/ R
            MACRO_d1 = MACRO_d[i] + 1
        elseif rnd <  (Hb + Hd + microflorab + microflorad + MICROFAUNA_db + MICROFAUNA_dd + MICROFAUNA_pb + MICROFAUNA_pd+
                        MESOFAUNA_db + MESOFAUNA_dd + MESOFAUNA_pd + MACRO_db + MACRO_dd)/ R
            MACRO_d1 = MACRO_d[i] - 1

        elseif rnd <  (Hb + Hd + microflorab + microflorad + MICROFAUNA_db + MICROFAUNA_dd + MICROFAUNA_pb + MICROFAUNA_pd+
                        MESOFAUNA_db + MESOFAUNA_dd + MESOFAUNA_pd + MACRO_db + MACRO_dd + MACRO_pb)/ R
            MACRO_p1 = MACRO_p[i] + 1

        else
            MACRO_p1 = MACRO_p[i] - 1
        end

        #Valores menores que cero no existen

        if MACRO_p1<= 0.0
            MACRO_p1 = 0.0
        end
        if MACRO_d1<= 0.0
            MACRO_d1 = 0.0
        end

        if MESOFAUNA_p1<= 0.0
            MESOFAUNA_p1 = 0.0
        end

        if MESOFAUNA_d1<=0.0
            MESOFAUNA_d1 = 0.0
        end

        if MICROFAUNA_p1<=0.0
            MICROFAUNA_p1 = 0.0
        end

        if MICROFAUNA_d1<=0.0
            MICROFAUNA_d1 = 0.0
        end

        if microflora1 <= 0.0
            microflora1 = 0.0
        end

        if H1 <= 0.0
            H1 = 0.0
        end

        i += 1

        #DEVOLVER vectores de poblacionales

        push!(H,H1)
        push!(microflora,microflora1)
        push!(MICROFAUNA_d,MICROFAUNA_d1)
        push!(MICROFAUNA_p,MICROFAUNA_p1)
        push!(MESOFAUNA_d,MESOFAUNA_d1)
        push!(MESOFAUNA_p,MESOFAUNA_p1)
        push!(MACRO_d,MACRO_d1)
        push!(MACRO_p,MACRO_p1)

        #Devolver vector de tiempo
        push!(ts,t)
    end
    #devolver vectores
    return ts,H,microflora,MICROFAUNA_d,MICROFAUNA_p,MESOFAUNA_d,MESOFAUNA_p,MACRO_d,MACRO_p
end

u0 = [200.0, 105, 90, 85, 60, 50, 70, 40]
p = [50, 10, 50, 30, 12, 4, 40, 25, 6, 0.5, 0.7, 0.65, 0.8, 0.6, 0.8, 0.75, 0.67, 0.7, 0.67, 0.6, 0.8, 0.4, 0.6, 0.7,
     0.7,0.65,0.4,0.6,0.7,0.7,0.7,0.4,0.5,0.6]

tfinal=5
t,H,mi,mfD,mfP,msD,msP,maD,maP = lotka_stoc(p,u0,tfinal)
plot(t,H, label="Hojarasca")
plot!(t,mi, label="Microflora")
plot!(t,mfD, label="Microfauna detritivora")
plot!(t,mfP, label="Microfauana Predadora")
plot!(t,msD, label="Mesofauan Detritívora")
plot!(t,msP, label="Mesofauna Predadora")
plot!(t,maD, label="Macrofauna Detritívora")
plot!(t,maP, label="Macrofauna predadora")

"""La Aproximación Bayesiana por Rechazo es un algoritmo de muestreo utilizado para inferir parámetros en modelos relacionados con la ecología de sistemas complejos. Este algoritmo se basa en la teoría bayesiana y utiliza la probabilidad de los datos observados para estimar los parámetros desconocidos. En la Aproximación Bayesiana por Rechazo , se generan muestras aleatorias de los parámetros del modelo utilizando una distribución de probabilidad inicial. Luego, se evalúa la verosimilitud de los datos observados dadas las muestras generadas y se compara con un umbral de aceptación. Si la verosimilitud está por encima del umbral, la muestra se acepta como una aproximación del valor verdadero del parámetro. Si la verosimilitud está por debajo del umbral, la muestra se descarta y se genera una nueva muestra.

Este proceso se repite varias veces para obtener una distribución de probabilidad aproximada de los parámetros del modelo. Al finalizar, se puede utilizar esta distribución para realizar inferencias sobre los parámetros y realizar predicciones en el contexto de la ecología de sistemas complejos.

Es importante tener en cuenta que la Aproximación Bayesiana por Rechazo es solo uno de los muchos algoritmos de muestreo utilizados en la inferencia bayesiana. Cada algoritmo tiene sus propias ventajas y desventajas, y la elección del algoritmo dependerá del contexto y los requisitos particulares del problema.

https://academia-lab.com/enciclopedia/calculo-bayesiano-aproximado/

"""


