"""
    ECUACIONES modelo RED SUELO

    Enfoque de grandes grupos 
    Para simplificar las interacciones: HOJARASCA - MICROFLORA (descomponedores) - MESOFAUNA (microfitofagos - predadores)
    MICROFAUNA (microfitofagos - predadores)
        a = ingreso
        b = crecimiento microflora
        c = crecimiento microfauna_d
        d = desaparición
        e = eficiencia descomposición
        ea = eficiencia asimilacion microflora
        mmp = muerte microfauna predadora
        MICROFAUNA_d = microfauna microfitofaga
        MESOFAUNA_d = mesofauna microfitofaga
        MICROFAUNA_p = microfauna predadora
        MESOFAUNA_p = microfauna predadora

    δHojarasca = a - H*microflora*e - d*H
    δMicroflora = b*microflora + H*microflora*f - MICROFAUNA_d*microflora - MESOFAUNA_d*microflora
    δMicrofauna_d = c*Microfauna_d - MESOFAUNA_p*Microfauna_d - Microfauna_p*Microfauna_d
    δMicrofauna_p = Microfauna_p*Microfauna_d - mmp*Microfauna_p - mesofauna_p*Microfauna_p
    
"""