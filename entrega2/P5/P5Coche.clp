; Cristina Sánchez Justicia 

;;; convertimos cada evidencia en una afirmación sobre su factor de certeza
(defrule certeza_evidencias
    (Evidencia ?e ?r)
        =>
    (assert (FactorCerteza ?e ?r 1)) 
)
;; También podríamos considerar evidencias con una cierta
;;incertidumbre: al preguntar por la evidencia, pedir y recoger
;;directamente el grado de certeza

; Función encadenado
(deffunction encadenado (?fc_antecedente ?fc_regla)
    
    (if (> ?fc_antecedente 0) then
        (bind ?rv (* ?fc_antecedente ?fc_regla))
    else
        (bind ?rv 0) 
    )
    ?rv
)

;   R1: SI el motor obtiene gasolina Y el motor gira ENTONCES problemas con las bujías con certeza 0,7
(defrule R1
    (FactorCerteza motor_llega_gasolina si ?f1)
    (FactorCerteza gira_motor si ?f2)
    (test (and (> ?f1 0) (> ?f2 0)))
        =>
    (bind ?expl (str-cat "motor obtiene gasolina y el motor gira"))
    (assert (FartorCerteza problema_bujias si (encadenado (* ?f1 ?f2) 0.7)))
)

; # EJERCICIO
;   R2: SI NO gira el motor ENTONCES problema con el starter con certeza 0,8
(defrule R2
    (FactorCerteza gira_motor no ?f1)
    (test (> ?f1 0))
        =>
    (bind ?expl (str-cat "no gira el motor"))
    (assert (FactorCerteza problema_starter si (encadenado ?f1 0.8) ?expl))    
)

;   R3: SI NO encienden las luces ENTONCES problemas con la batería con certeza 0,9
(defrule R3
    (FactorCerteza encienden_las_luces no ?f1)
    (test (> ?f1 0))
        =>
    (bind ?expl (str-cat "no encienden las luces"))
    (assert (FactorCerteza problema_bateria si (encadenado ?f1 0.9) ?expl))
)

;   R4: SI hay gasolina en el deposito ENTONCES el motor obtiene gasolina con certeza 0,9
(defrule R4
    (FactorCerteza hay_gasolina_en_deposito si ?f1)
    (test (> ?f1 0))
        =>
    (assert (FactorCerteza motor_llega_gasolina si (encadenado ?f1 0.9)))
)

;   R5: SI hace intentos de arrancar ENTONCES problema con el starter con certeza -0,6
(defrule R5
    (FactorCerteza hace_intentos_arrancar si ?f1)
    (test (> ?f1 0))
        =>
    (bind ?expl (str-cat "hace intentos de arrancar"))
    (assert (FactorCerteza problema_starter si (encadenado ?f1 -0.6) ?expl))
    (assert (FactorCerteza problema_bateria si (encadenado ?f1 0.5) ?expl))
)


(deftemplate Certeza
    (field problema)
    (field valor)
    (field explanation)    
)

; Certeza de las hipótesis
(deffunction combinacion (?fc1 ?fc2)
    
    (if (and (> ?fc1 0) (> ?fc2 0) ) then
        (bind ?rv (- (+ ?fc1 ?fc2) (* ?fc1 ?fc2) ) )
    else
        (if (and (< ?fc1 0) (< ?fc2 0) )
    then
        (bind ?rv (+ (+ ?fc1 ?fc2) (* ?fc1 ?fc2) ) )
    else
        (bind ?rv (/ (+ ?fc1 ?fc2) (- 1 (min (abs ?fc1) (abs ?fc2))) )))
    )

    ?rv
)

(defrule combinar
    (declare (salience 1))
    ?f <- (FactorCerteza ?h ?r ?fc1 ?expl1)
    ?g <- (FactorCerteza ?h ?r ?fc2 ?expl2)
    (test (neq ?fc1 ?fc2))
        =>
    (retract ?f ?g)
    (bind ?expl3 (str-cat ?expl1 ", " ?expl2))
    (assert (FactorCerteza ?h ?r (combinacion ?fc1 ?fc2) ?expl3)) 
)

; Certeza de las hipótesis

(defrule getCertainty
    (declare (salience -1))
    (FactorCerteza ?h ?ans ?value ?expl)
    =>
    (assert (Certeza (problema ?h) (valor ?value) (explanation ?expl)))
)

; # EJERCICIO

;   - Preguntar por las posibles evidencias:

(deffacts validAnswers
    (validAns si no)
)

(defrule startUp
        =>
    (printout t crlf crlf"--- Practica 5.2: Factores de Certeza ---" crlf)
    (printout t crlf ">>Tu coche tiene problemas.")
    (assert (question hace_intentos_arrancar))
)

(defrule firstQuestion
    ?f <- (question hace_intentos_arrancar)
        =>
    (printout t crlf "--- PREGUNTA ---" crlf  ">>Hace intentos para arrancar?" crlf ">>(Si | No)" crlf ">")
    (assert (Evidencia  hace_intentos_arrancar (lowcase(read))))
    (assert (question hay_gasolina_en_deposito))
    (retract ?f)
)

(defrule secondQuestion
    ?f <- (question hay_gasolina_en_deposito)
        =>
    (printout t crlf "--- PREGUNTA ---" crlf  ">>Tiene gasolina en el deposito?" crlf ">>(Si | No)" crlf ">")
    (assert (Evidencia hay_gasolina_en_deposito (lowcase(read))))
    (assert (question encienden_las_luces))
    (retract ?f)
)

(defrule thirdQuestion
    ?f <- (question encienden_las_luces)
        =>
    (printout t crlf "--- PREGUNTA ---" crlf  ">>Encienden las luces?" crlf ">>(Si | No)" crlf ">")
    (assert (Evidencia encienden_las_luces (lowcase(read))))
    (assert (question gira_motor))
    (retract ?f)
)

(defrule fourthQuestion
    ?f <- (question gira_motor)
        =>
    (printout t crlf "--- PREGUNTA ---" crlf  ">>Gira el motor?" crlf ">>(Si | No)" crlf ">")
    (assert (Evidencia gira_motor (lowcase(read))))
    (retract ?f)
    (assert (razonar))
)

; # EJERCICIO

(deffacts prettyName
    (prettyName problema_bateria "la bateria")
    (prettyName problema_starter "el starter")
    (prettyName problema_bujias "las bujias")
)

;   - Tras razonar quedarse con la hipótesis con mayor certeza.
(defrule giveAnswer
    (razonar)
    (Certeza (problema ?name1) (valor ?value1) (explanation ?expl))
    (prettyName ?name1 ?prettyName)
    (not (Certeza (valor ?value2&:(> ?value2 ?value1))))
        =>
    (printout t crlf "### RESPUESTA ###" crlf ">> El problema puede ser con " ?prettyName " con una certeza del " (* ?value1 100) "% porque: " ?expl "." crlf)
)