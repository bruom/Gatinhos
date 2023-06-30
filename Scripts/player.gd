class_name Player extends CharacterBody3D

signal on_hit(collider)
signal on_item_use(item_id)

@onready var cat: Cat = $cat
@onready var anim_player: AnimationPlayer = get_node("cat/cat/AnimationPlayer")
@onready var noise_emitter: NoiseEmitter = $NoiseEmitter

@export var speed: float = 1.0
@export var run_speed: float = 1.2
@export var sneak_speed: float = 0.5
@export var sound_radius: float = 1.5
@export var run_sound_multiplier: float = 1.5
@export var sneak_sound_multiplier: float = 0.5
var current_sound_radius: float = 0.0
var items = {
	1: 0, #Toy
	2: 0  #Catnip
}

enum State { IDLE, WALK, RUN, SNEAK }
var current_state: State = State.IDLE
var current_interacting_node: InteractibleObject = null

func _ready():
	cat.footstep_occured.connect(Callable(_on_cat_footstep_occured))
	
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
		
	if current_interacting_node != null:
		var range: float = current_interacting_node.interaction_range
		if global_position.distance_squared_to(current_interacting_node.global_position) > range * range:
			current_interacting_node.currently_interacting = false 
			current_interacting_node = null
		if !Input.is_action_pressed("Interact"):
			current_interacting_node.currently_interacting = false
			current_interacting_node = null
	
	if current_interacting_node == null:
		var interactible_node: InteractibleObject = get_closest_interactible()
		if interactible_node != null:
			interactible_node.set_ui_visible(true)
			if Input.is_action_just_pressed("Interact"):
				current_interacting_node = interactible_node
				interactible_node.currently_interacting = true
		else:
			for i_node in get_tree().get_nodes_in_group("interactible"):
				i_node.set_ui_visible(false)
	
	if Input.is_action_just_pressed("UseItem1"):
		use_item(1)
	
	move_and_slide()
	_process_collision()

func _process_collision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		on_hit.emit(collider)

func get_closest_interactible():
	var interactible_nodes = get_tree().get_nodes_in_group("interactible")
	interactible_nodes = interactible_nodes.filter(func(n): return n.interaction_enabled)
	interactible_nodes.sort_custom(func(a, b):
		return global_position.distance_squared_to(a.global_position) < global_position.distance_squared_to(b.global_position)
	)
	var closest_interactible: InteractibleObject = null
	for i_node in interactible_nodes:
		var range = i_node.interaction_range
		if global_position.distance_squared_to(i_node.global_position) <= range * range:
			closest_interactible = i_node
			break
	return closest_interactible

func blink():
	cat.set_face_uv_offset(Vector2(0.5, 0.0))
			
func _on_cat_footstep_occured():
	if current_state == State.RUN:
		noise_emitter.emit_noise(sound_radius * run_sound_multiplier)
	elif current_state == State.WALK:
		noise_emitter.emit_noise(sound_radius)
	elif current_state == State.SNEAK:
		noise_emitter.emit_noise(sound_radius * sneak_sound_multiplier)
		
func pickup_item(item_id: int):
	self.items[item_id] += 1
		
func use_item(item_type):
	if items[item_type] > 0:
		items[item_type] -= 1
		on_item_use.emit(item_type)
