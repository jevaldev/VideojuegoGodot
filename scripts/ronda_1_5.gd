extends Timer

@export var enemigo1:  PackedScene
@export var enemigo2:  PackedScene
@export var enemigo3:  PackedScene

@onready var path = preload("res://scenes/Paths/Nivel1.tscn")
@onready var texture_progress_bar: TextureProgressBar = $"../../CanvasLayer/TextureProgressBar"
@onready var label: Label = $"../../CanvasLayer/Labels/Label"


@onready var timer_enemigo_1: Timer = $Enemigo1
@onready var timer_enemigo_2: Timer = $Enemigo2
@onready var timer_enemigo_3: Timer = $Enemigo3

var cantidadEnemigo1 = 5
var cantidadEnemigo2 = 2
var cantidadEnemigo3 = 1
var ronda = 1

func _ready() -> void:
	wait_time_spawn(timer_enemigo_1, cantidadEnemigo1)
	wait_time_spawn(timer_enemigo_2, cantidadEnemigo2)
	wait_time_spawn(timer_enemigo_3, cantidadEnemigo3)

func _on_enemigo_1_timeout() -> void:
	spawn_mob(enemigo1)

func _on_enemigo_2_timeout() -> void:
	spawn_mob(enemigo2)
	
func _on_enemigo_3_timeout() -> void:
	spawn_mob(enemigo3)


# Función para actualizar el temporizador de la ronda
func actualizar_timer_ronda():
	if ronda == 2:
		self.wait_time += 10
		self.start(self.wait_time)
		# Actualiza la barra de progreso
		actualizar_barra_progreso()

# Función para actualizar el temporizador de los enemigos
func actualizar_timer_enemigos(ronda):
	if ronda == 2:
		cantidadEnemigo1 += randi_range(5, 10)
		wait_time_spawn(timer_enemigo_1, cantidadEnemigo1)
	elif ronda == 3:
		cantidadEnemigo1 += randi_range(25, 35)
		wait_time_spawn(timer_enemigo_1, cantidadEnemigo1)
		cantidadEnemigo2 += randi_range(5, 15)
		wait_time_spawn(timer_enemigo_2, cantidadEnemigo2)
	elif ronda == 5:
		timer_enemigo_1.wait_time = 1

# Función para ajustar el tiempo de spawn de enemigos
func wait_time_spawn(timer, enemyQuantity):
	timer.wait_time = self.wait_time / enemyQuantity

# Función para crear los enemigos
func spawn_mob(enemy):
	var tempPath = path.instantiate()
	tempPath.get_child(0).add_child(enemy.instantiate())
	var random_y = randi_range(-6, 6) * 5
	tempPath.get_child(0).get_child(0).position.y = random_y
	add_child(tempPath)


func _on_timeout() -> void:
	ronda += 1
	label.text = "Ronda " + str(ronda)
	actualizar_timer_enemigos(ronda)
	actualizar_timer_ronda()

# Función que maneja la barra de progreso
func actualizar_barra_progreso():
	texture_progress_bar.max_value = self.wait_time  # Ajusta el máximo al nuevo tiempo
	texture_progress_bar.value = 0  # Reinicia el valor de la barra para la nueva ronda
