; Cristina Sánchez Justicia 

(deffacts relaciones_causa_efecto
  (influye  zona_origen covid)    ; Zona de origen influye en la probabilidad de COVID
  (influye  vacuna covid)         ; El estar vacunado influye en la probabilidad del COVID  
  (efecto fiebre covid)           ; Tener fiebre es un efecto o síntoma común del COVID
  (efecto tos covid)              ; Tener tos es un efecto o síntoma común del COVID
  (efecto pcr covid)              ; Se le realiza un test a los afectados por COVID
)

(deffacts probabilidad_variables_que_influyen
  (prob zona_origen alto_riesgo 0.7)
  (prob zona_origen medio_riesgo 0.2)
  (prob zona_origen bajo_riesgo 0.1)
  (prob vacuna si 0.2)
  (prob vacuna no 0.8)
)

(deffacts distribucion_segun_valores_variables_que_influyen
  (probcond2 covid SI zona_origen alto_riesgo vacuna si 0.002)
  (probcond2 covid SI zona_origen alto_riesgo vacuna no 0.045)
  (probcond2 covid SI zona_origen medio_riesgo vacuna si 0.0015)
  (probcond2 covid SI zona_origen medio_riesgo vacuna no 0.03)
  (probcond2 covid SI zona_origen bajo_riesgo vacuna si 0.0002)
  (probcond2 covid SI zona_origen bajo_riesgo vacuna no 0.009)
)

(deffacts probabilidad_efectos
  (probcond tos si covid SI 0.09)
  (probcond tos si covid NO 0.3)
  (probcond fiebre alta covid SI 0.004)
  (probcond fiebre alta covid NO 0.0025)
  (probcond fiebre media covid SI 0.02)
  (probcond fiebre media covid NO 0.009)
  (probcond fiebre no covid SI 0.04)
  (probcond fiebre no covid NO 0.1)
  (probcond pcr si covid SI 0.9)
  (probcond pcr no covid NO 0.99)
)
; Inicializamos valores para calculos a partir de probcond2
(deffacts inicializacion_probabilidades
  (probconj2 covid SI zona_origen alto_riesgo 0)
  (probconj2 covid SI zona_origen medio_riesgo 0)
  (probconj2 covid SI zona_origen bajo_riesgo 0)
  (probconj2 covid SI vacuna si 0)
  (probconj2 covid SI vacuna no 0)
  (prob covid SI 0)
)

(defrule inicio
    =>
  (printout t "Este es un sistema para decidir si usted padece covid" crlf)
  (assert (informar datos))
  (printout t crlf crlf "DATOS: Los datos estadísticos de que dispongo son:" crlf)
)

;;;; MODULO INFORMAR DATOS ;;;;

(defrule mostrar_prob_simples
(declare (salience 10))
(informar datos)
(influye ?i ?X) 
(prob ?i ?v  ?p)
=>
(printout t "Probabilidad de " ?i "=" ?v " es " ?p crlf)
)

(defrule mostrar_prob_condicionales
(declare (salience 9))
(informar datos)
(efecto ?e ?X) 
(probcond ?e ?v ?X SI ?p)
=>
(printout t "Probabilidad de " ?e "=" ?v " si " ?X " es " ?p crlf)
)

(defrule mostrar_prob_condicionales_bis
(declare (salience 9))
(informar datos)
(efecto ?e ?X) 
(probcond ?e ?v ?X NO ?p)
=>
(printout t "Probabilidad de " ?e "=" ?v " si no " ?X " es " ?p crlf)
)

(defrule mostrar_prob_condicionales2
(declare (salience 8))
(informar datos)
(probcond2 ?X SI ?i1 ?v1 ?i2 ?v2 ?p)
=>
(printout t "Probabilidad de " ?X " si " ?i1 "=" ?v1 " y " ?i2 "=" ?v2 " es " ?p crlf)
)

(defrule ir_a_deducciones_simples
(informar datos)
=>
(printout t crlf crlf "DEDUCCIONES SIMPLES:" crlf)
(assert (deducciones simples))
)

;;;;;;;  MODULO DEDUCCIONES SIMPLES

(defrule calcula_condicionada_negado
(declare (salience 3))
(deducciones simples)
(probcond ?e si ?X ?v ?p)
=>
(assert (probcond ?e no ?X ?v (- 1 ?p)))
)

(defrule probconj3
(declare (salience 2))
(deducciones simples)
(probcond2 ?X SI ?c1 ?v1 ?c2 ?v2 ?pc)
(prob ?c1 ?v1 ?p1)
(prob ?c2 ?v2 ?p2)
=>
(bind ?p (* (* ?pc ?p1) ?p2))
(assert (probconj3 ?X SI ?c1 ?v1 ?c2 ?v2 ?p))
(assert (sumar probconj2 ?X SI ?c1 ?v1 ?p))
(assert (sumar probconj2 ?X SI ?c2 ?v2 ?p))
(assert (sumar prob ?X SI ?p))
)

(defrule probconj2
(declare (salience 3))
(deducciones simples)
?f <- (probconj2 ?X SI ?c ?v ?p)
?g <- (sumar probconj2 ?X SI ?c ?v ?p1)
=>
(assert (probconj2 ?X SI ?c ?v (+ ?p ?p1)))
(retract ?f ?g)
)

(defrule calcula_probabilidad_condicionada
(declare (salience 1))
(deducciones simples)
(probconj2 ?X SI ?c ?v ?p)
(prob ?c ?v ?pc)
=>
(assert (probcond ?X SI ?c ?v (/ ?p ?pc)))
)


(defrule calcula_probabilidad
(declare (salience 2))
(deducciones simples)
?f <- (prob ?X SI ?p)
?g <- (sumar prob ?X SI ?pc)
=>
(assert (prob ?X SI (+ ?p ?pc)))
(retract ?f ?g)
)

(defrule mostrar_prob_condicionales_tris
(deducciones simples)
(probcond ?X SI ?i ?v ?p)
=>
(printout t "Probabilidad de " ?X " si " ?i "=" ?v " es " ?p crlf)
)

(defrule Informa_probabilidad_a_priori
(declare (salience -1))
(deducciones simples)
(prob ?X SI ?p)
=>
(printout t crlf crlf "--> Segun los datos estadisticos: " crlf)
(printout t crlf "A PRIORI: la probabilidad de " ?X " es: " ?p crlf)
(printout t crlf)
)

(defrule ir_a_red_causal_causas
(declare (salience -2))
?f <- (deducciones simples)
=>
(printout t crlf crlf "INDAGANDO: Vamos a indagar en base a esos datos" crlf)
(retract ?f)
(assert (red causal causas))
)

;;;;;; MODULO RED CAUSAL CAUSAS

(defrule inferencia0causas
(red causal causas)
(influye ?c1 ?X)
(influye ?c2 ?X)
(test (neq ?c1 ?c2))
(valor ?c1 Desconocido)
(valor ?c2 Desconocido)
(prob ?X SI ?p)
=>
(assert (prob_posteriori_causas ?X ?p))
(assert (prob_conjunta ?X ?p))
(assert (prob_conjunta_negativo ?X (- 1 ?p)))
)

(defrule inferencia1causas
(red causal causas)
(influye ?c1 ?X)
(influye ?c2 ?X)
(valor ?c1 ?v1)
(valor ?c2 Desconocido)
(probcond ?X SI ?c1 ?v1 ?p+x/c)
(prob ?c1 ?v1 ?p)
=>
(assert (prob_posteriori_causas ?X ?p+x/c))
(assert (prob_conjunta ?X (* ?p ?p+x/c)))
(assert (prob_conjunta_negativo ?X (* ?p (- 1 ?p+x/c))))
(printout t  "--> " ?c1 " influye en la probabilidad de " ?X crlf)
(printout t "--> Como " ?c1 " toma el valor " ?v1 ":" crlf)
(printout t crlf "CON ESOS FACTORES: La probabilidad de " ?X " ha cambiado a " ?p+x/c crlf)
(printout t crlf)
)

(defrule inferencia2causas
(red causal causas)
(influye ?c1 ?X)
(influye ?c2 ?X)
(test (neq ?c1 ?c2))
(valor ?c1 ?v1)
(valor ?c2 ?v2)
(probcond2 ?X SI ?c1 ?v1 ?c2 ?v2 ?p+x/c1c2)
(prob ?c1 ?v1 ?p1)
(prob ?c2 ?v2 ?p2)
=>
(assert (prob_posteriori_causas ?X  ?p+x/c1c2))
(assert (prob_conjunta ?X (* ?p2 (* ?p1 ?p+x/c1c2))))
(assert (prob_conjunta_negativo ?X (* ?p2 (* ?p1 (- 1 ?p+x/c1c2)))))
(printout t  "---> " ?c1 " y " ?c2 " influyen la probabilidad de " ?X crlf)
(printout t "--->  Como " ?c1 " toma el valor " ?v1 " y " ?c2 " toma el valor " ?v2 ":" crlf)
(printout t crlf "CON ESOS FACTORES: La probabilidad de " ?X " ha cambiado a " ?p+x/c1c2 crlf)
(printout t crlf)
)

(defrule ir_a_red_causal_efectos
(declare (salience -1))
?f <- (red causal causas)
=>
(printout t crlf crlf "BUSCANDO INDICIOS" crlf)
(retract ?f)
(assert (red causal efectos))
)
  
;;;;; MODULO RED CAUSAL EFECTOS   
  
(defrule redcausal1efecto
(red causal efectos)
(efecto ?e ?X) 
(valor ?e ?v & ~Desconocido)
(probcond ?e ?v ?X SI ?pe/+x)
(probcond ?e ?v ?X NO ?pe/-x)
=>
(assert (multiplicar prob_conjunta ?pe/+x)) 
(assert (multiplicar prob_conjunta_negativo ?pe/-x)) 
(printout t "--> " ?e " es un efecto de " ?X ". Como " ?e " toma el valor " ?v ":" crlf)
(printout t "--> vamos a utilizarlo para actualizar la probabilidad de " ?X crlf)
(printout t crlf)
)

(defrule actualizar_prob_conjunta
(red causal efectos)
?f <- (prob_conjunta ?X ?p+x)
?g <- (multiplicar prob_conjunta ?pe/+x)
=>
(bind ?p+x+e (* ?pe/+x ?p+x))
(assert (prob_conjunta ?X ?p+x+e))
(retract ?f ?g) 
)

(defrule actualizar_prob_conjunta_negativa
(red causal efectos)
?f <- (prob_conjunta_negativo ?X ?p)
?g <- (multiplicar prob_conjunta_negativo ?pe)
=>
(assert (prob_conjunta_negativo ?X (* ?p ?pe)))
(retract ?f ?g) 
)

(defrule prob_posteriori
(declare (salience -1))
(red causal efectos)
(prob_conjunta ?X ?p+x)
(prob_conjunta_negativo ?X ?p-x)
=>
(bind ?pc (+ ?p+x ?p-x))
(bind ?p (/ ?p+x ?pc))
(assert (prob_posteriori ?X ?p))
(printout t "FINALMENTE: Por el teorema de bayes a probabilidad de " ?X " ha cambiado a " ?p crlf)
(printout t crlf)
)

  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;   PARA PROBARLO  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  Normalmente los valores de las variables que influyen se deducen a partir
;;;  de datos a mas bajo nivel (por ejemplo a partir del pais se deduce la zona
;;;  de riesgo, o a traves del grupo sangíneo se deduce la vacuna
;;;  Los síntomas o efectos a veces se deducen y otras veces son introducidos por
;;;  el usuario
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defrule preguntar_zona_origen
  (red causal causas)
    =>
  (printout t crlf crlf"--- Practica 5.4: Redes Bayesianas ---" crlf)
  (printout t crlf ">>Probabilidad que alguien tenga COVID. ")
  (printout t crlf "--- PREGUNTA ---" crlf ">>Que riesgo tiene la zona de residencia?" crlf">>(1 - Alto | 2 - Medio | 3 - Bajo | 4 - Desconocido)" crlf ">")
  (bind ?respuesta (read))
  (if (= ?respuesta 1) then (assert (valor zona_origen alto_riesgo))
    else (if (= ?respuesta 2) then (assert (valor zona_origen medio_riesgo))
      else (if (= ?respuesta 3) then (assert (valor zona_origen bajo_riesgo))
    else (assert (valor zona_origen Desconocido)))))
  (printout t crlf)	 
)

(defrule preguntar_vacuna
  (red causal causas)
    =>
  (printout t crlf "--- PREGUNTA ---" crlf ">>Esta vacunado el paciente? "crlf">>(1 - Si | 2 - No | 3 - Desconocido)" crlf ">")
  (bind ?respuesta (read))
  (if (= ?respuesta 1) then (assert (valor vacuna si))
    else (if (= ?respuesta 2) then (assert (valor vacuna no))
    else (assert (valor vacuna Desconocido))))
  (printout t crlf)
)

(defrule preguntar_fiebre
  (red causal efectos)
    =>
  (printout t crlf "--- PREGUNTA ---" crlf ">>Ha tenido fiebre?" crlf ">>(1 - Alta | 2 - Media | 3 - No | 4 - Desconocido)" crlf ">")
  (bind ?respuesta (read))
  (if (= ?respuesta 1) then 
        (assert (valor fiebre alta))
      else (if (= ?respuesta 2) then 
        (assert (valor fiebre media))
      else (if (= ?respuesta 3) then 
        (assert (valor fiebre no)) 
      else 
        (assert (valor fiebre Desconocido))))
  )
  (printout t crlf)
)

(defrule preguntar_tos
  (red causal efectos)
    =>
  (printout t crlf "--- PREGUNTA ---" crlf ">>Ha tenido tos?" crlf ">>(1 - Si | 2 - No | 3 - Desconocido)" crlf ">")
  (bind ?respuesta (read))
  (if (= ?respuesta 1) then (assert (valor tos si))
    else (if (= ?respuesta 2) then (assert (valor tos no))
    else (assert (valor tos Desconocido))))
  (printout t crlf)
)

(defrule preguntar_pcr
  (red causal efectos)
    =>
  (printout t crlf "--- PREGUNTA ---" crlf ">>Si se ha realizado el PCR, ha dado positivo? (1 - Si | 2 - No | 3 - No se ha realizado el test)" crlf ">")
  (bind ?respuesta (read))
  (if (= ?respuesta 1) then (assert (valor pcr si))
    else (if (= ?respuesta 2) then (assert (valor pcr no))
    else (assert (valor pcr Desconocido))))
  (printout t crlf)
)