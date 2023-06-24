extends CharacterBody3D

@export var speed: float = 1.0
@export var sound_radius: float = 1.5
var current_sound_radius: float = 0.0

func _process(delta):
	RenderingServer.global_shader_parameter_set("player_position", global_position)
	var direciton: Vector2 = Input.get_vector("Left", "Right", "Forward", "Backward")
	velocity = Vector3(direciton.x, 0.0, direciton.y).normalized() * speed
	if velocity != Vector3.ZERO:
		current_sound_radius = sound_radius
		look_at(global_position + velocity)
		move_and_slide()
	else:
		current_sound_radius = 0.0
