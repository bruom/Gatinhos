class_name InteractibleObject extends Node3D

@onready var progress_indicator = $progress_indicator
@onready var progress_circle = $progress_indicator/progress_circle
@onready var contextual_action_label = $progress_indicator/progress_circle/contextual_action_label

@export var interaction_enabled: bool = true
@export var interaction_time: float = 1.0
@export var interaction_range: float = 0.3

var interaction_hint: String = "INTERACT":
	set(value):
		interaction_hint = value
		contextual_action_label.text = value

var main_camera: Camera3D
var currently_interacting: bool = false
var current_interaction_time: float = 0.0

func _ready():
	main_camera = get_viewport().get_camera_3d()
	add_to_group("interactible")

func _process(delta):
	upate_screen_position()
	if currently_interacting:
		set_ui_visible(true)
		current_interaction_time += delta
		if current_interaction_time >= interaction_time:
			interaction_completed()
			currently_interacting = false
			set_ui_visible(false)
	else:
		current_interaction_time = 0.0
	progress_circle.material.set_shader_parameter("upper_bound", current_interaction_time / interaction_time)

func set_ui_visible(_visible: bool):
	progress_indicator.visible = _visible

func interaction_completed():
	pass

func upate_screen_position():
	if progress_indicator != null:
		progress_indicator.position = main_camera.unproject_position(global_position)
		progress_circle.position.y = -1 * (120.0 + ((12 - main_camera.size) * 20.0))
