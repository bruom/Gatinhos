class_name InteractibleObject extends Node3D

@export var interaction_enabled: bool = true
@export var interaction_time: float = 1.0
@export var interaction_range: float = 0.3

var currently_interacting: bool = false
var current_interaction_time: float = 0.0

func _ready():
	add_to_group("interactible")

func _process(delta):
	if currently_interacting:
		current_interaction_time += delta
		if current_interaction_time >= interaction_time:
			interaction_completed()
			currently_interacting = false
	else:
		current_interaction_time = 0.0

func interaction_completed():
	pass
