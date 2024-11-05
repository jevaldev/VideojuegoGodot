extends Area2D

@export var health_component : Health_Component

func damage(attack: Attack):
	if health_component:
		health_component.damage(attack)
