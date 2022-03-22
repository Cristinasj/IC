; Datos de personas 

(deftemplate Persona 
    (field Nombre)
    (field Edad)
    (field Sexo)
    (field EstadoCivil))

(deffacts Yo (Persona 
            (Nombre Cristina)
            (Edad 20) 
            (EstadoCivil soltera)
            (Sexo M)))

(defrule )