extends Control

@onready var grid_container: GridContainer = %GridContainer

func _ready() -> void:
	setup_level_box()
	connect_level_selected_to_level_box()
	
func setup_level_box():
	var level_count = 1  # Variable para contar los niveles
	for box in grid_container.get_children():
		box.level_num = level_count  # Asigna el número del nivel
		box.set_level_num(box.level_num)
		
		# Bloquea los niveles 3, 4, y 5
		if level_count in [3, 4, 5]:
			box.locked = true
			box.set_disabled(true)  # Desactiva la caja visualmente si es necesario
		else:
			box.locked = false
		level_count += 1  # Incrementa el número para el siguiente botón

func connect_level_selected_to_level_box():
	for box in grid_container.get_children():
		box.connect("level_selected", change_to_scene)
		
func change_to_scene(level_num: int):
	var next_level: String = "res://scenes/Levels/Level" +str(level_num) + ".tscn"
	if FileAccess.file_exists(next_level): get_tree().change_scene_to_file(next_level)
	
