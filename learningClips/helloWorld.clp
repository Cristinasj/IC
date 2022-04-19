; Datos de personas 

;(deftemplate Persona 
;    (field Nombre)
;    (field Edad)
;    (field Sexo)
;    (field EstadoCivil))

;(deffacts Yo 
;    (Persona 
;            (Nombre Cristina)
;            (Edad 21) 
;            (EstadoCivil soltera)
;            (Sexo M)
;    )
; )

(deffacts Hechos (Persona Cristina 21 soltera M))


(defrule CristinaTiene21Anos
    (Persona Cristina 21 soltera M) 
    => 
    (printout t crlf "Cristina tiene 21 años")
)