extends CharacterBody2D

@export var bulletDMG = 5

var traveled_distance = 0
const RANGE = 350
var target
var speed = 1000
var pathName = ""
	

# Dentro de tu script de la bala
func _ready() -> void:
	# Configura un temporizador para eliminar la bala después de un tiempo
	var timer = Timer.new()
	timer.wait_time = 2  # Tiempo en segundos antes de eliminar la bala
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_timeout"))
	add_child(timer)
	timer.start()

func _on_timeout() -> void:
	queue_free()  # Elimina la bala


func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta
	traveled_distance += speed * delta
	if traveled_distance > RANGE:
		queue_free() 



# Cuando la bala entra en contacto con un enemigo
func _on_area_2d_body_entered(body: Node2D) -> void:
	if "Enemigo" in body.name:  # Asegúrate de que el nombre coincida
		body.apply_damage(bulletDMG)  # Llama a apply_damage en el enemigo
		queue_free()  # Elimina la bala después de causar daño
