extends Timer

@export var enemigo1: PackedScene
@export var enemigo2: PackedScene
@export var enemigo3: PackedScene

@onready var path = preload("res://scenes/Paths/Nivel1.tscn")
@onready var texture_progress_bar: TextureProgressBar = $"../../CanvasLayer/TextureProgressBar"
@onready var label: Label = $"../../CanvasLayer/Labels/Ronda"

@onready var timer_enemigo_1: Timer = $Enemigo1
@onready var timer_enemigo_2: Timer = $Enemigo2
@onready var timer_enemigo_3: Timer = $Enemigo3

var cantidadEnemigo1 = 5
var cantidadEnemigo2 = 2
var cantidadEnemigo3 = 1
var ronda = 1
var min_wait_time = 0.5  # Tiempo mínimo entre spawn de enemigos

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
	self.wait_time = max(min_wait_time, self.wait_time - 1)  # Reduce el tiempo de ronda hasta el límite mínimo
	self.start(self.wait_time)
	actualizar_barra_progreso()

# Función para actualizar el temporizador y cantidad de enemigos por ronda
func actualizar_timer_enemigos(ronda):
	# Aumenta progresivamente la cantidad de enemigos en cada ronda de forma lineal
	cantidadEnemigo1 += randi_range(3, 5)
	if ronda > 2:
		cantidadEnemigo2 += randi_range(1, 3)
	if ronda > 4:
		cantidadEnemigo3 += randi_range(1, 2)

	wait_time_spawn(timer_enemigo_1, cantidadEnemigo1)
	wait_time_spawn(timer_enemigo_2, cantidadEnemigo2)
	wait_time_spawn(timer_enemigo_3, cantidadEnemigo3)


# Función para ajustar el tiempo de spawn de enemigos
func wait_time_spawn(timer, enemyQuantity):
	timer.wait_time = max(min_wait_time, self.wait_time / enemyQuantity)

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
	texture_progress_bar.max_value = self.wait_time
	texture_progress_bar.value = 0
