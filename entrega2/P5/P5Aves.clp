; Cristina Sánchez Justicia 

; # HECHOS de las transparencias 

; Las aves y los mamíferos son animales
;Los gorriones, las palomas, las águilas y los pingüinos son aves
;La vaca, los perros y los caballos son mamíferos
;Los pingüinos no vuelan
(deffacts datos
    (ave gorrion) 
    (ave paloma) 
    (ave aguila) 
    (ave pinguino)
    (mamifero vaca) 
    (mamifero perro) 
    (mamifero caballo)
    (vuela pinguino no seguro) 
)

; # REGLAS

; Las aves son animales
(defrule aves_son_animales
    (ave ?x)
        =>
    (assert (animal ?x))
    (bind ?expl (str-cat "sabemos que un " ?x " es un animal porque las aves son un tipo de animal"))
    (assert (explicacion animal ?x ?expl)) 
)

; Los mamiferos son animales 
(defrule mamiferos_son_animales
    (mamifero ?x)
        =>
    (assert (animal ?x))
    (bind ?expl (str-cat "Sabemos que un " ?x " es un animal porque los mamiferos son un tipo de animal"))
    (assert (explicacion animal ?x ?expl)) 
)

;; Casi todos las aves vuela --> puedo asumir por defecto que las aves vuelan
; Asumimos por defecto
(defrule ave_vuela_por_defecto
    (declare (salience -1)) ; para disminuir probabilidad de añadir erróneamente
    (ave ?x)
        =>
    (assert (vuela ?x si por_defecto))
    (bind ?expl (str-cat "asumo que un " ?x " vuela, porque casi todas las aves vuelan"))
    (assert (explicacion vuela ?x ?expl)) 
)

;;; La mayor parte de los animales no vuelan --> puede interesarme asumir por defecto
(defrule mayor_parte_animales_no_vuelan
    (declare (salience -2)) ;;;; es mas arriesgado, mejor después de otros razonamientos
    (animal ?x)
    (not (vuela ?x ? ?))
        =>
    (assert (vuela ?x no por_defecto))
    (bind ?expl (str-cat "asumo que " ?x " no vuela, porque la mayor parte de los animales no vuelan"))
    (assert (explicacion vuela ?x ?expl)) 
)


; MAIN  

(defrule startUp
    (declare (salience -10))
        =>
    (printout t crlf crlf"--- Practica 5.1: Reglas por Defecto ---" crlf)
    (printout t crlf "--- PREGUNTA ---" crlf ">>Escribe el nombre de un animal para saber si vuela o no." crlf ">")
    (assert (inputAnimal ( lowcase(read) ) ) )
)

;   -   Si es uno de los recogidos en el conocimiento indique si vuela o no
(defrule checkAnimal
    ; El animal que se ha introducido está en la base de conocimientos.
    (inputAnimal ?specimen)
    (animal ?specimen)
    ; Se toman las explicaciones y se imprimen en pantalla.
    (explicacion animal ?specimen ?expl1)
    (explicacion vuela|retracta_vuela ?specimen ?expl2)
    =>
    (printout t crlf "### RESPUESTA ###" crlf ">>" ?expl1 "; " ?expl2 "." crlf)
    (assert (animalIsKnown))
)

(defrule checkAnimal_2
    ; Cuando se ha introducido un nuevo animal que no es mamifero o ave, se dispara esta regla.
    (inputAnimal ?specimen)
    (animal ?specimen)
    ; No posee la explicación del animal pero si la de que si vuela o no.
    (not(explicacion animal ?specimen ?expl1))
    (explicacion vuela|retracta_vuela ?specimen ?expl2)
    =>
    (printout t crlf "### RESPUESTA ###" crlf ">>" ?expl2 "." crlf)
    (assert (animalIsKnown))
)