extends CharacterBody2D

@export var animacion: AnimatedSprite2D
@export var speed: float = 100
@export var health: int = 10

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var main_node = get_tree().root.get_node("Game")
@onready var label = main_node.get_node("CanvasLayer/Labels/Monedas")
@onready var vida = main_node.get_node("CanvasLayer/Labels/Vida")

# Called every frame. 'delta' is the elapsed time since the previous frame.
# Emitir la señal con el tipo de enemigo como parámetro
func _process(delta: float) -> void:
	get_parent().set_progress(get_parent().get_progress()+ speed * delta )
	if get_parent().get_progress_ratio() == 1:
		if health > 30:
			main_node.player_health -= 5
			vida.text = str(main_node.player_health)
			if main_node.player_health <= 0:
				main_node.get_node("GameOver").visible = true
		else:
			main_node.player_health -= 1
			vida.text = str(main_node.player_health)
			if main_node.player_health <= 0:
				main_node.get_node("GameOver").visible = true
		get_parent().get_parent().queue_free()
		
# Función que maneja el daño recibido y la animación
func apply_damage(damage: int) -> void:
	health -= damage
	if health > 0: 
		play_hurt()  
	else:
		collision_layer = 8
		speed = 0
		animacion.play("muerte")
		main_node.coins += randi_range(80, 120)  # Actualizamos el valor de 'coins' en el nodo "Game"
		label.text = str(main_node.coins)
		await animacion.animation_finished
		get_parent().get_parent().queue_free()
		
		
func play_hurt() -> void:
	if health > 0: 
		if animacion:  
			animacion.play("hurt")
			await animacion.animation_finished
			animacion.play("walk")  
		else:
			print("AnimatedSprite2D no encontrado")
	else:
		print("El enemigo ya está muerto, no se reproduce la animación de daño")
