class_name Player extends CharacterBody3D

signal on_hit(collider)

@onready var cat: Cat = $cat
@onready var anim_player: AnimationPlayer = get_node("cat/cat/AnimationPlayer")
@onready var noise_emitter: NoiseEmitter = $NoiseEmitter

@export var speed: float = 1.0
@export var run_speed: float = 1.2
@export var sneak_speed: float = 0.5
@export var sound_radius: float = 1.5
@export var item_placer: PackedScene
var current_sound_radius: float = 0.0
var items = {
	1: 0, #Toy
	2: 0  #Catnip
}

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

func blink():
	cat.set_face_uv_offset(Vector2(0.5, 0.0))
			

func _on_cat_footstep_occured():
	if current_state in [State.RUN, State.WALK]:
		noise_emitter.emit_noise()
	elif current_state == State.SNEAK:
		noise_emitter.emit_noise()
		
func pickup_item(item):
	self.items[item.item_type] += 1
	item.remove_from_group("PlacedItems")
	
func _input(event):
	if event.is_action_pressed("UseItem1"):
		self.use_item(1)
	if event.is_action_pressed("UseItem2"):
		self.use_item(2)
		
func use_item(item_type):
	if items[item_type] > 0:
		print("Using item: " + str(item_type))
		items[item_type] -= 1
		var new_item = item_placer.instantiate()
		get_parent().add_child(new_item)
		new_item.position = self.global_position
		new_item.position.y += 0.1
		new_item.item_type = item_type
		new_item.active = true
		new_item.item_placed()
	else:
		print("No item of type: " + str(item_type))
