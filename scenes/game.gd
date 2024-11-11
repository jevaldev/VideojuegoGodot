extends Node2D

@onready var ronda_1_5: Timer = $"Rondas/Ronda 1-5"
@onready var texture_progress_bar: TextureProgressBar = $CanvasLayer/TextureProgressBar
@onready var vida: Label = $CanvasLayer/Labels/Vida
@onready var monedas: Label = get_node("TowerUI/Monedas")
@onready var label: Label = $CanvasLayer/Labels/Label

var player_health = 100
var coins = randi_range(1000, 1500)


func _ready():
	# Configurar el valor máximo de la barra de progreso igual al tiempo del temporizador
	#texture_progress_bar.max_value = ronda_1_5.wait_time
	#texture_progress_bar.value = 0  # Iniciar en 0
	label.text = str(ronda_1_5.wait_time)
	vida.text = str(player_health)
	monedas.text = str(coins)
	

func _process(delta):
	#Actualizar el texto del label con el tiempo restante formateado
	label.text = format_time(ronda_1_5.time_left)

# Función para convertir el tiempo restante en minutos y segundos
func format_time(tiempo_restante: float) -> String:
	var minutos = int(tiempo_restante) / 60
	var segundos = int(tiempo_restante) % 60
	return str(minutos) + ":" + str("%02d" % segundos)  # Formato "min:seg"
