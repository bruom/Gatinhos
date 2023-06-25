class_name Player extends CharacterBody3D

signal on_hit(collider)

@onready var cat: Cat = $cat
@onready var anim_player: AnimationPlayer = get_node("cat/cat/AnimationPlayer")
@onready var noise_emitter: NoiseEmitter = $NoiseEmitter

@export var speed: float = 1.0
@export var run_speed: float = 1.2
@export var sneak_speed: float = 0.5
var current_sound_radius: float = 0.0

enum State { IDLE, WALK, RUN, SNEAK }
var current_state: State = State.IDLE

func _process(delta):
	RenderingServer.global_shader_parameter_set("player_position", global_position)
	var direciton: Vector2 = Input.get_vector("Left", "Right", "Forward", "Backward")
	velocity = Vector3(direciton.x, 0.0, direciton.y).normalized() * speed
	if velocity != Vector3.ZERO:
		
		if Input.is_action_pressed("Run"):
			current_state = State.RUN
			anim_player.play("cat_run")
			anim_player
			velocity = velocity * run_speed;
			cat.set_tail_motion_parameters(1.5, 1.0)
		elif Input.is_action_pressed("Sneak"):
			current_state = State.SNEAK
			anim_player.play("cat_sneak")
			velocity = velocity * sneak_speed;
			cat.set_tail_motion_parameters(1.0, 0.7)
		else:
			current_state = State.WALK
			anim_player.play("cat_walk")
			cat.set_tail_motion_parameters(1.0, 1.0)
		look_at(global_position + velocity)
	else:
		current_state = State.IDLE
		anim_player.play("cat_idle")
		current_sound_radius = 0.0
	
	move_and_slide()
	_process_collision()

func _process_collision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		on_hit.emit(collider)
			

func _on_cat_footstep_occured():
	if current_state in [State.RUN, State.WALK]:
		noise_emitter.emit_noise()
	elif current_state == State.SNEAK:
		noise_emitter.emit_noise()
		
