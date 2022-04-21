; Cristina Sánchez Justicia 
; El sistema utiliza las siguientes propiedades: 
; Gusto por las matemáticas, puede tomar los valores Mucho Medio y Bajo, (Interes_mates Alto|Medio|Bajo), se preguntará
; Si le interesa el hardware con valores Mucho Medio y Bajo(Interes_hw Alto|Medio|Bajo), se preguntará
; Gusto por las bases de datos con valores Mucho Medio y Bajo  (Interes_bd Alto|Medio|Bajo), se preguntará
; Gusto por las redes  con valores Mucho Medio y Bajo(Interes_redes Alto|Medio|Bajo), se preguntará
; Gusto por programar  con valores Mucho Medio y Bajo,(Interes_prog Alto|Medio|Bajo), se deducirá a partir de su gusto en el hardware

; Representación de las ramas como dice la presentación 
(deffacts Ramas 
    (Rama Computación_y_Sistemas_Inteligentes)
    (Rama Ingeniería_del_Software)
    (Rama Ingeniería_de_Computadores)
    (Rama Sistemas_de_Información)
    (Rama Tecnologías_de_la_Información)    
)

; Representación de la sujerencia 
; (Consejo <nombre de la rama> "<texto del motivo>")

; Preguntas que se harán 