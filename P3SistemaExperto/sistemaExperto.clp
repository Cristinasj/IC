; Cristina Sánchez Justicia 
; El sistema utiliza las siguientes propiedades: 
; Gusto por las matemáticas, puede tomar los valores Mucho Medio y Bajo, (Interes mates Alto|Medio|Bajo), se preguntará
; Si le interesa el hardware con valores Mucho Medio y Bajo(Interes hw Alto|Medio|Bajo), se preguntará
; Gusto por las bases de datos con valores Mucho Medio y Bajo  (Interes bd Alto|Medio|Bajo), se preguntará
; Gusto por las redes  con valores Mucho Medio y Bajo(Interes redes Alto|Medio|Bajo), se preguntará
; Gusto por programar  con valores Mucho Medio y Bajo,(Interes prog Alto|Medio|Bajo), se preguntará
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Para las sugerencias, voy a basarme en una habilidad que se entrene mucho en cada mención.
; - CSI tiene asociadas las matemáticas.
; - IS  tiene asociada la programación 
; - TIC tiene asociadas las redes 
; - SI  tiene asociadas las bases de datos
; - IC  tiene asociado el hardware
; Se preguntará al alumno su preferencia por cada habilidad. Si hay una que destaca, se recomendará su mención asociada. 
; Si hay dos que empatan, se desempatará dando prioridad a las asignaturas por popularidad. La popularidad de las menciones va en este orden: 
; En primer lugar CSI, luego IS, TIC, SI y por último IC  
; Si no le gusta nada, se recomendará TIC ya que es la más general 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Preguntas  
(defrule Pregunta_mates (declare (salience 1000))
=> 
(printout t crlf "¿Cuánto es su interés por las matemáticas?" crlf "Responda Mucho, Medio o Bajo" crlf "Si no sabe qué responder, responda Medio" crlf) (assert (Interes mates (read))))

(defrule Pregunta_hw (declare (salience 1000))
=>
(printout t crlf "¿Cuánto es su interés por el hardware? " crlf "Responda Mucho, Medio o Bajo" crlf "Si no sabe qué responder, responda Medio" crlf) (assert (Interes hw (read))))

(defrule Pregunta_bd (declare (salience 1000)) 
=>
(printout t crlf "¿Cuánto es su interés por las bases de datos? " crlf "Responda Mucho, Medio o Bajo" crlf "Si no sabe qué responder, responda Medio" crlf) (assert (Interes bd (read))))

(defrule Pregunta_redes (declare (salience 1000)) 
=>
(printout t crlf "¿Cuánto es su interés por las redes? " crlf "Responda Mucho, Medio o Bajo" crlf "Si no sabe qué responder, responda Medio" crlf) (assert (Interes redes (read))))

(defrule Pregunta_prog (declare (salience 1000)) 
=>
(printout t crlf "¿Cuánto es su interés por la programación? " crlf "Responda Mucho, Medio o Bajo" crlf "Si no sabe qué responder, responda Medio" crlf) (assert (Interes prog (read))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Representación de la sujerencia 
; (Consejo <nombre de la rama> "<texto del motivo>")

; Representación de las ramas como dice la presentación 
(deffacts Ramas 
    (Rama Computación_y_Sistemas_Inteligentes)
    (Rama Ingeniería_del_Software)
    (Rama Ingeniería_de_Computadores)
    (Rama Sistemas_de_Información)
    (Rama Tecnologías_de_la_Información)    
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Calculo de las sugerencia 
; Hay 3⁵ = 9 · 9 · 3 = 9 · 27 = 180 + 63 = 243 posibles respuestas 

; Cuando solo le gusta mucho una de las especialidades. Es decir, tiene vocación clara 
; Aquí se cubren 5 · 2⁴ = 5 · 16 = 80 posibles respuestas 
(defrule VocacionCSI 
(Interes mates Mucho)
(Interes prog ~Mucho)
(Interes bd ~Mucho)
(Interes hw ~Mucho)
(Interes redes ~Mucho)
=> 
(assert (Consejo Computación_y_Sistemas_Inteligentes "verá muchas matemáticas")))


(defrule VocacionIC 
(Interes mates ~Mucho)
(Interes prog ~Mucho)
(Interes bd ~Mucho)
(Interes hw Mucho)
(Interes redes ~Mucho)
=> 
(assert (Consejo Ingeniería_de_Computadores "verá mucho hardware")))

(defrule VocacionTSI 
(Interes mates ~Mucho)
(Interes prog ~Mucho)
(Interes bd ~Mucho)
(Interes hw ~Mucho)
(Interes redes Mucho)
=> 
(assert (Consejo Tecnologías_de_la_Información "verá muchas redes ")))

(defrule VocacionIS 
(Interes mates ~Mucho)
(Interes prog Mucho)
(Interes bd ~Mucho)
(Interes hw ~Mucho)
(Interes redes ~Mucho)
=> 
(assert (Consejo  Ingeniería_del_Software "verá mucha programación ")))


(defrule VocacionSI 
(Interes mates ~Mucho)
(Interes prog ~Mucho)
(Interes bd Mucho)
(Interes hw ~Mucho)
(Interes redes ~Mucho)
=> 
(assert (Consejo Sistemas_de_Información "verá muchas bases de datos ")))

; Cuando no ha respondido Mucho a ninguna pero hay una que le gusta más que las demás. Es decir, tiene una preferencia por una. 

;(defrule PreferenciaCSI (Interes hw & bd & prog & redes Bajo) (Interes mates Medio)
;=>
;(assert (Consejo Computación_y_Sistemas_Inteligentes "no le desagradan las matemáticas")))

;(defrule PreferenciaIS (Interes hw & bd & mates & redes Bajo) (Interes prog Medio)
;=>
;(assert (Consejo  Ingeniería_del_Software "no le desagrada la programación ")))

;(defrule PreferenciaTIC (Interes hw & bd & prog & mates Bajo) (Interes redes Medio)
;=>
;(assert (Consejo Tecnologías_de_la_Información "no le desagradan las redes ")))

;(defrule PreferenciaSI (Interes hw & mates & prog & redes Bajo) (Interes bd Medio)
;=>
;(assert (Consejo Sistemas_de_Información "no le desagradan las bases de datos")))

;(defrule PreferenciaIC (Interes mates & bd & prog & redes Bajo) (Interes hw Medio)
;=>
;(assert (Consejo Ingeniería_de_Computadores "no le desagrada el hardware ")))

; Cuando ha respondido Bajo a todas 

(defrule Nada (Interes mates Bajo) (Interes bd Bajo) (Interes hw Bajo) (Interes redes Bajo) (Interes prog Bajo) 
=>
(assert (Consejo Tecnologías_de_la_Información "es la mención más general")))

; Cuando ha respondido Mucho a varias  
(defrule EmpateCSI (Interes mates Mucho)(Interes bd | prog | redes | hw Mucho)
=> 
(assert (Consejo Computación_y_Sistemas_Inteligentes "es popular entre es popular entre el resto de los alumnos y no le va a decepcionar")))

(defrule EmpateIS (Interes prog Mucho) (Interes bd | redes | hw Mucho)
=> 
(assert (Consejo Ingeniería_del_Software "es popular entre es popular entre el resto de los alumnos y no le va a decepcionar")))

(defrule EmpateTIC (Interes redes Mucho) (Interes bd | hw Mucho)
=> 
(assert (Consejo Tecnologías_de_la_Información "es popular entre es popular entre el resto de los alumnos y no le va a decepcionar")))

(defrule EmpateSI (Interes bd Mucho) (Interes hw Mucho)
=> 
(assert (Consejo  "es popular entre es popular entre el resto de los alumnos y no le va a decepcionar")))

; Cuando no ha respondido Mucho a ninguna y ha respondido Medio a varias 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Imprimir resultados 
(defrule Resultados (declare(salience 10000))
(Consejo ?rama ?motivo)
=> 
(printout t crlf "Se le aconseja " ?rama " porque " ?motivo crlf crlf))