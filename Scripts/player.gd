class_name Player extends CharacterBody3D

signal on_hit(collider)

@onready var anim_player: AnimationPlayer = get_node("cat/cat/AnimationPlayer")
@onready var footsteps_SFX = get_node("Footsteps SFX")

@export var speed: float = 1.0
@export var run_speed: float = 1.2
@export var sneak_speed: float = 0.5
@export var sound_radius: float = 1.5
@export var play_sfx: bool = true
var current_sound_radius: float = 0.0

func _process(delta):
	RenderingServer.global_shader_parameter_set("player_position", global_position)
	var direciton: Vector2 = Input.get_vector("Left", "Right", "Forward", "Backward")
	velocity = Vector3(direciton.x, 0.0, direciton.y).normalized() * speed
	if velocity != Vector3.ZERO:
		
		if Input.is_action_pressed("Run"):
			anim_player.play("cat_run")
			velocity = velocity * run_speed;
		elif Input.is_action_pressed("Sneak"):
			anim_player.play("cat_sneak")
			velocity = velocity * sneak_speed;
		else:
			anim_player.play("cat_walk")
		current_sound_radius = sound_radius
		look_at(global_position + velocity)
		if !footsteps_SFX.playing && play_sfx:
			footsteps_SFX.play()
	else:
		anim_player.play("cat_idle")
		current_sound_radius = 0.0
	
	move_and_slide()
	_process_collision()

func _process_collision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		on_hit.emit(collider)
			
