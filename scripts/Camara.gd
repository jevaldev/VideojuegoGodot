extends Camera2D

var _target_zoom: float = 1
const MIN_ZOOM: float = 1
const MAX_ZOOM: float = 1.8
const ZOOM_INCREMENT: float = 0.1
const ZOOM_RATE: float = 8.0

func _physics_process(delta: float) -> void:
	# Interpolamos entre el zoom actual y el _target_zoom usando lerp para Vector2
	zoom = zoom.lerp(Vector2(_target_zoom, _target_zoom), ZOOM_RATE * delta)

	# Detenemos el procesamiento de la física si el zoom ha alcanzado el valor objetivo
	set_physics_process(not is_equal_approx(zoom.x, _target_zoom))

# Función para controlar los botones del mouse
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_RIGHT:
			position -= event.relative * zoom
	elif event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom_in()
			elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom_out()

func zoom_in() -> void:
	_target_zoom = max(_target_zoom - ZOOM_INCREMENT, MIN_ZOOM)
	set_physics_process(true)

func zoom_out() -> void:
	_target_zoom = min(_target_zoom + ZOOM_INCREMENT, MAX_ZOOM)
	set_physics_process(true)
