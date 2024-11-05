#Codigo creado por Jesus Alejandro Valdes Viramontes
extends Area2D

#Llamar a los nodos del juego principal
@onready var main_node = get_tree().root.get_node("Game")
@onready var label = main_node.get_node("CanvasLayer/Labels/Monedas")

#Llamar a los nodos del CanvasLayer para seleccionar la torre 
@onready var tower_ui = get_tree().get_root().get_node("Game/TowerUI")
@onready var flow_container = tower_ui.get_node("Panel/FlowContainer")

#Llamar a los nodos del CanvasLayer para mejorar la torre
@onready var tower_upgrades_ui = get_node("TowerUpgradesUI")
@onready var label_dmg: Label = tower_upgrades_ui.get_node("Panel/FlowContainer/Daño")
@onready var label_speed: Label = tower_upgrades_ui.get_node("Panel/FlowContainer/Velocidad")
@onready var label_level: Label = tower_upgrades_ui.get_node("Panel/FlowContainer/Mejorar/Nivel")
@onready var panel_icon: Panel = tower_upgrades_ui.get_node("Panel/FlowContainer/TorretaTiraChina2")
@onready var boton_mejora: TextureButton = $BotonMejora
@onready var mejorar: CanvasLayer = $Mejorar

var base_seleccionada = null

#Funcion que se ejecuta cada segunda, en este caso para cambiar los labels de las mejoras
func _process(delta: float) -> void:
	if tower_upgrades_ui.visible == false:
		mejorar.visible = false
	if get_child_count() == 7:
		var tower = get_child(6)  # Obtener la torre que está colocada en la posición
		
		# Obtener los valores de la torre
		var bullet_dmg = tower.bulletDMG
		var attack_speed = tower.FPS 
		var level = tower.nivel
		
		label_level.text = "Nivel " + str(level)
		label_dmg.text = "Daño:    " + str(bullet_dmg)
		label_speed.text = "Velocidad\n" + "disparo: "+ str(attack_speed)

#Función que registra eventos en este caso un input personalizado 
func _input_event(viewport, event, shape_idx):
	print(get_child_count())
	if event.is_action_pressed("Interactuar"):
		
		# Si hay una torre en la base (get_child_count() == 7 indica que hay una torre)
		if get_child_count() == 7:
			var tower = get_child(6)  # Obtener la torre que está colocada en la ultima posición
			mejorar.visible = true
			tower_upgrades_ui.visible = true
			
			# Obtener los valores de la torre
			var bullet_dmg = tower.bulletDMG
			var attack_speed = tower.FPS 
			var tower_icon = tower.get_node("Sprite2D").texture  # Obtener el ícono automáticamente
			var level = tower.nivel
			
			# Actualizar los labels en la UI
			label_level.text = "Nivel " + str(level)
			label_dmg.text = "Daño:    " + str(bullet_dmg)
			label_speed.text = "Velocidad\n" + "disparo: "+ str(attack_speed)
			
			# Mostrar el ícono de la torre en el panel
			panel_icon.get_node("TorretaSprite").texture = tower_icon
			panel_icon.get_node("Label").visible = false
		else:
			# No hay torre, mostrar UI para colocar nueva torre
			tower_upgrades_ui.visible = false
			tower_ui.visible = true
			set_selected_base_for_torres(self)

func set_selected_base_for_torres(base):
	# Iterar sobre todos los hijos del FlowContainer
	for Torreta in flow_container.get_children():
		if Torreta is Panel:  # Asegurarse de que el nodo sea un Panel
			Torreta.set_selected_base(base)  # Pasar la base seleccionada a cada torre

func colocarTorre(tower_scene):
	#if tower_scene != null:
	var tempTower = tower_scene.instantiate()
	add_child(tempTower)
	#else:
		#print("No se ha seleccionado ninguna torre para colocar.")

func _on_boton_mejora_pressed() -> void:
	var tower = get_child(6) 
	if 600 <= main_node.coins:
		main_node.coins -= 600
		label.text = str(main_node.coins)
		tower.mejorar_torre()
	else:
		var escasez_label = mejorar.get_node("Escasez")
		escasez_label.visible = true
		await get_tree().create_timer(2.0).timeout  # Espera 2 segundos
		escasez_label.visible = false
		
func _on_texture_button_pressed() -> void:
	tower_ui.visible = false
	tower_upgrades_ui.visible = false
