extends Panel

#Exportacion de variables para modificar cada uno independientemente
@export var towerScene:  PackedScene
@export var icon: CompressedTexture2D
@export var cost: int = 900

#Declaracion de variables escenas o nodos ya creados
@onready var tower_ui = get_tree().get_root().get_node("Game/TowerUI")
@onready var texture_rect: TextureRect = $TorretaSprite
@onready var main_node = get_tree().root.get_node("Game")
@onready var label = main_node.get_node("TowerUI/Monedas")
@onready var labelInterno: Label = $Label


var selected_base = null  # La base seleccionada
var selected_tower # La base seleccionada

# Función para actualizar la UI solo cuando el panel sea visible
func _process(delta: float) -> void:
	if tower_ui.visible:
		check_cost()
	
# Función para verificar si el jugador tiene suficiente dinero
func check_cost():
	if cost > main_node.coins:
		modulate = Color(0.5, 0.5, 0.5, 0.8)  # Hacer el panel más gris
	else:
		modulate = Color(1, 1, 1, 1)  # Restaurar el color original

func _ready() -> void:
	labelInterno.text = str(cost)
	add_to_group("char")
	texture_rect.texture = icon
	
func set_selected_base(base):
	selected_base = base

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_mask == 1:
		if selected_base != null and towerScene != null:
			if cost <= main_node.coins:
				main_node.coins -= cost
				label.text = str(main_node.coins)
				selected_base.colocarTorre(towerScene)  # Colocar la torre en la base seleccionada
				tower_ui.visible = false
			else:
				label.text = "Eres pobre"
		else:
			label.text = "Eres pobre"
			check_cost()  # Verificar si el jugador tiene dinero suficiente


func _on_texture_button_pressed() -> void:
	tower_ui.visible = false
