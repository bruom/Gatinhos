extends CharacterBody3D

@onready var sound_debug: MeshInstance3D = $sound_debug

@export var speed: float = 1.0
@export var run_speed: float = 1.2
@export var sneak_speed: float = 0.5
@export var sound_radius: float = 1.5
@export var play_sfx: bool = true
@onready var footsteps_SFX = get_node("Footsteps SFX")
var current_sound_radius: float = 0.0

func _process(delta):
	var direciton: Vector2 = Input.get_vector("Left", "Right", "Forward", "Backward")
	velocity = Vector3(direciton.x, 0.0, direciton.y).normalized() * speed
	if velocity != Vector3.ZERO:
		if Input.is_action_pressed("Run"):
			velocity = velocity * run_speed;
		elif Input.is_action_pressed("Sneak"):
			velocity = velocity * sneak_speed;
		current_sound_radius = sound_radius
		look_at(global_position + velocity)
		if !footsteps_SFX.playing && play_sfx:
			footsteps_SFX.play()
		move_and_slide()
	else:
		current_sound_radius = 0.0
		
