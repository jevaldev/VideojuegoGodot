@tool
extends TextureButton

signal level_selected


@export var level_num: int = 1
@export var locked: bool = true: 
	set(value):
		locked = value
		level_locked() if locked else level_unlocked()
		

# Actualizar el número del nivel y el texto del Label
func set_level_num(value: int) -> void:
	level_num = value
	update_label()  # Actualiza el Label cada vez que se cambia el nivel

# Métodos para cambiar el estado del nivel
func level_locked() -> void:
	level_state(true)
	
func level_unlocked() -> void:
	level_state(false)
	
# Cambiar el estado del botón y visibilidad del Label
func level_state(value: bool) -> void:
	disabled = value
	$Label.visible = not value

# Actualizar el texto del Label
func update_label() -> void:
	$Label.text = str(level_num)  # Cambia el texto del Label al valor de level_num

func _on_pressed() -> void:
	level_selected.emit(level_num)
