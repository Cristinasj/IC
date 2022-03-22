; Autora Cristina Sánchez Justicia IC subgrupo A1 
; HECHOS GENERALES DEL SISTEMA 
(deffacts personas
    (mujer Emilia) 
    (hombre Cristobal)
    (hombre JoseLuis)
    (mujer Cristina)
    (mujer Veronica)
    (mujer Brigida)
    (hombre Manuel)
    (mujer IreneTita)
    (mujer Pepi)
    (hombre Jose)
    (hombre AntonioTito)
    (hombre AntonioPrimo)
    (mujer IrenePrima)
    (hombre Paco)
    (hombre Pedro)
    (mujer Soraya)
)

(deftemplate Relacion
    (slot tipo (type SYMBOL) (allowed-symbols HIJO PADRE ABUELO NIETO HERMANO ESPOSO PRIMO TIO SOBRINO CUNIADO YERNO SUEGRO))
    (slot sujeto)
    (slot objeto)
)

(deffacts relaciones
    (Relacion (tipo HIJO) (sujeto Emilia) (objeto Brigida))
    (Relacion (tipo HIJO) (sujeto Cristobal) (objeto LuisaAbuela))
    (Relacion (tipo HIJO) (sujeto JoseLuis) (objeto Emilia))
    (Relacion (tipo HIJO) (sujeto Cristina) (objeto Emilia))
    (Relacion (tipo HIJO) (sujeto Veronica) (objeto Emilia))
    (Relacion (tipo HIJO) (sujeto IreneTita) (objeto Brigida))
    (Relacion (tipo HIJO) (sujeto Pepi) (objeto Brigida))
    (Relacion (tipo HIJO) (sujeto Jose) (objeto Brigida))
    (Relacion (tipo HIJO) (sujeto AntonioPrimo) (objeto IreneTita))
    (Relacion (tipo HIJO) (sujeto IrenePrima) (objeto IreneTita))
    (Relacion (tipo HIJO) (sujeto Pedro) (objeto Pepi))
    (Relacion (tipo ESPOSO) (sujeto Cristobal) (objeto Emilia))
    (Relacion (tipo ESPOSO) (sujeto Manuel) (objeto Brigida))
    (Relacion (tipo ESPOSO) (sujeto AntonioTito) (objeto IreneTita))
    (Relacion (tipo ESPOSO) (sujeto Paco) (objeto Pepi))
    (Relacion (tipo ESPOSO) (sujeto Soraya) (objeto Jose))
)

(deffacts duales
    (dual HIJO PADRE) (dual ABUELO NIETO) (dual HERMANO HERMANO) (dual ESPOSO ESPOSO) (dual PRIMO PRIMO) (dual TIO SOBRINO) (dual CUNIADO CUNIADO) (DUAL YERNO SUEGRO)
)

(deffacts compuetos
    (comp HIJO HIJO NIETO) (comp PADRE PADRE ABUELO) (comp ESPOSO PADRE PADRE) (comp HERMANO PADRE TIO) (comp HERMANO ESPOSO CUNIADO) (comp ESPOSO HIJO YERNO) (comp ESPOSO HERMANO CUNIADO) (comp HIJO PADRE HERMANO) (comp ESPOSO CUNIADO CUNIADO) (comp ESPOSO TIO TIO) (comp HIJO TIO PRIMO)
)

(deffacts femenino (femenino HIJO HIJA) (femenino PADRE MADRE) (femenino ABUELO ABUELA) (femenino NIETO NIETA) (femenino HERMANO HERMANA) (femenino ESPOSO ESPOSA) (femenino PRIMO PRIMA) (femenino TIO TIA) (femenino SOBRINO SOBRINA) (femenino CUNIADO CUNIADA) (femenino YERNO NUERA) (femenino SUEGRO SUEGRA)
)

;;;; REGLAS DEL SISTEMA 

(defrule autodualidad
    (razonar)
    (dual ?r ?t) => (assert (dual ?t ?r))
)

(defrule dualidad 
    (razonar)
    (Relacion (tipo ?r) (sujeto ?x) (objeto ?y))
    (dual ?r ?t) => (assert (Relacion (tipo ?t) (sujeto ?y) (objeto ?x)))
)

(defrule composicion
   (Relacion (tipo ?r) (sujeto ?y) (objeto ?x))
   (Relacion (tipo ?t) (sujeto ?x) (objeto ?z))
   (comp ?r ?t ?u)
   (test (neq ?y ?z))
=> 
   (assert (Relacion (tipo ?u) (sujeto ?y) (objeto ?z))))

(defrule limpiacuniados
    (Relacion (tipo HERMANO) (sujeto ?x) (objeto ?y))
    ?f <- (Relacion (tipo CUNIADO) (sujeto ?x) (objeto ?y))
=>
	(retract ?f) )

(defrule pregunta 
=>
   (printout t "Dime el nombre de la primera persona de la Familia Sánchez Justicia sobre la que quieres información (escribe solo el nombre): " crlf)
   (assert (primerapersona (read))))

(defrule pregunta2
(primerapersona ?primero)
=>
   (printout t "Dime el nombre de la persona de la Familia Sánchez Justicia de la que quieres saber su relacion con " ?primero " (escribe solo el nombre): " crlf)
   (assert (segundapersona (read)))
   (assert (razonar))  )

(defrule relacionmasculino
   ?f <- (razonar)
   (primerapersona ?x)		
   (segundapersona ?y)
   (Relacion (tipo ?r) (sujeto ?y) (objeto ?x))
   (hombre ?y)
 =>
   (printout t ?y " es " ?r " de " ?x crlf)
   (retract ?f)   )

(defrule relacionfemenino
    ?f <- (razonar)
   (primerapersona ?x)		
   (segundapersona ?y)
   (Relacion (tipo ?r) (sujeto ?y) (objeto ?x))
   (mujer ?y)
   (femenino ?r ?t)
 =>
   (printout t ?y " es " ?t " de " ?x crlf)
   (retract ?f)    )
