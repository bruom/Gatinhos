class_name Player extends CharacterBody3D

signal on_hit(collider)

@onready var cat: Cat = $cat
@onready var anim_player: AnimationPlayer = get_node("cat/cat/AnimationPlayer")
@onready var footsteps_SFX = get_node("Footsteps SFX")

@export var speed: float = 1.0
@export var run_speed: float = 1.2
@export var sneak_speed: float = 0.5
@export var sound_radius: float = 1.5
@export var play_sfx: bool = true
@export var item_placer: PackedScene
var current_sound_radius: float = 0.0
var items = {
	1: 0, #Toy
	2: 0  #Catnip
}

func _process(delta):
	RenderingServer.global_shader_parameter_set("player_position", global_position)
	var direciton: Vector2 = Input.get_vector("Left", "Right", "Forward", "Backward")
	velocity = Vector3(direciton.x, 0.0, direciton.y).normalized() * speed
	if velocity != Vector3.ZERO:
		
		if Input.is_action_pressed("Run"):
			anim_player.play("cat_run")
			velocity = velocity * run_speed;
			cat.set_tail_motion_parameters(1.5, 1.0)
		elif Input.is_action_pressed("Sneak"):
			anim_player.play("cat_sneak")
			velocity = velocity * sneak_speed;
			cat.set_tail_motion_parameters(1.0, 0.7)
		else:
			anim_player.play("cat_walk")
			cat.set_tail_motion_parameters(1.0, 1.0)
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

func blink():
	cat.set_face_uv_offset(Vector2(0.5, 0.0))
			
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
