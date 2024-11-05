extends StaticBody2D

@export var bulletScene: PackedScene
@export var armaAnimada: AnimatedSprite2D
@export var aim: Marker2D
@export var numeroFrame = 0
@export var lastFrame = 0
@export var bulletDMG: int = 10
@export var FPS: float = 1
@export var nivel = 1  # Nivel inicial de la torre
@export var damage_increment = 5  # Incremento de daño por nivel
@export var fps_increment: float = 0.7  # Incremento de FPS por nivel

var currntTargets = []
var timer_active = false
var curr

# Añadir el temporizador en el _ready() para que inicie automáticamente
func _ready() -> void:
	print(bulletScene)
	armaAnimada.connect("frame_changed", Callable(self, "_on_frame_changed"))

# Función para controlar el disparo al cambiar de frame en la animación
func _on_frame_changed() -> void:
	if armaAnimada.frame == numeroFrame:
		#print(timer_active, "hola")
		shoot()
		timer_active = false

# Función de disparo que se ejecuta cuando el temporizador hace timeout
func _on_timer_timeout() -> void:
	timer_active = true


# Cuando un enemigo sale del rango, actualizar los objetivos
func _on_tower_body_exited(body: Node2D) -> void:
	currntTargets = get_node("Tower").get_overlapping_bodies()
	if curr in currntTargets:
		curr = null


func _physics_process(delta: float) -> void:
	var enemies_in_range = get_node("Tower").get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front()
		armaAnimada.look_at(target_enemy.global_position)
		armaAnimada.rotation_degrees += 90
		armaAnimada.play("disparar")
	else: 
		if armaAnimada.frame == lastFrame:
			armaAnimada.stop()

func shoot():
	var tempBullet = bulletScene.instantiate()
	tempBullet.bulletDMG = bulletDMG
	tempBullet.global_position = aim.global_position
	tempBullet.global_rotation = aim.global_rotation
	aim.add_child(tempBullet)

# Función para mejorar la torre
func mejorar_torre() -> void:
	nivel += 1
	bulletDMG += damage_increment  # Incrementar el daño
	FPS += fps_increment  # Incrementar la velocidad de disparo
	armaAnimada.speed_scale = FPS  # Ajustar el playback_speed de la animación según el nuevo FPS
	print("Torre mejorada a nivel " + str(nivel) + ". Daño: " + str(bulletDMG) + ", Velocidad de ataque: " + str(FPS))
