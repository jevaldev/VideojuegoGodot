extends Control

@onready var ButtonResume: Button = $PanelContainer/VBoxContainer/Resume
@onready var ButtonRestart: Button = $PanelContainer/VBoxContainer/Restart
@onready var ButtonQuit: Button = $PanelContainer/VBoxContainer/Quit

func _ready() -> void:
	$AnimationPlayer.play("RESET")
	ButtonResume.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ButtonRestart.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hide_menu()  # Asegúrate de que el menú esté inicialmente oculto

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	hide_menu()
	
func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	show_menu()
	
func testEsc():
	if Input.is_action_just_pressed("Escape") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("Escape") and get_tree().paused == true:
		resume()

func _on_resume_pressed() -> void:
	resume()


func _on_restart_pressed() -> void:
	resume()
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	resume()
	# Cambia a la escena principal o al menú de selección
	get_tree().change_scene_to_file("res://scenes/GUI/level_select.tscn")

func _process(delta: float) -> void:
	testEsc()

# Funciones para mostrar/ocultar el menú
func show_menu() -> void:
	visible = true
	ButtonResume.mouse_filter = Control.MOUSE_FILTER_PASS
	ButtonRestart.mouse_filter = Control.MOUSE_FILTER_PASS

func hide_menu() -> void:
	visible = false
	ButtonResume.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ButtonRestart.mouse_filter = Control.MOUSE_FILTER_IGNORE
