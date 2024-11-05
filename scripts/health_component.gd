extends Node2D
class_name Health_Component

@export var MAX_HEALTH = 10
var health : float

func _ready() -> void:
	health = MAX_HEALTH
	
func apply_damage(damage: int) -> void:
	health -= damage
	if health > 0:  # Solo reproducir la animación si el enemigo sigue vivo
		get_parent().get_child(0).play_hurt()  
	else:
		queue_free()  # Elimina el enemigo si la salud llega a 0
