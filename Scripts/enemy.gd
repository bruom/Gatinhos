class_name Enemy extends CharacterBody3D

@onready var nav_agent: NavigationAgent3D = $nav_agent
@onready var cat: Cat = $cat
@onready var anim_player: AnimationPlayer = get_node("cat/cat/AnimationPlayer")
@onready var overhead_label: Label3D = $overhead_label

@export var target: Node3D
@export var vision_angle: float = 60
@export var speed: float = 1.0
@export var alert_speed_mult: float = 1.5
@export var looking_around_time: float = 3.5
@export var patrol_route: Array[Vector3] = []
@export var facing_directions: Array[Vector3] = []

signal on_hit(collider)

var current_patrol_index: int = 0
var mesh_instance: MeshInstance3D
var enemy_state: EnemyState = EnemyState.IDLE:
	set(value):
		enemy_state = value
		if value == EnemyState.ALERT:
			set_overhead_label("!", Color.RED)
		elif value == EnemyState.SUSPICIOUS:
			set_overhead_label("?", Color.GOLD)
		else:
			set_overhead_label("", Color.WHITE)

var chase_target
var investigation_target: Vector3
var remaining_looking_around_time: float = 0.0
var looking_around: bool = false
var sound_heard

enum EnemyState {
	IDLE,
	SUSPICIOUS,
	ALERT
}

func _physics_process(delta):
	var next_pos = nav_agent.get_next_path_position()
	keep_watch()
	if looking_around:
		anim_player.play("cat_look")
		remaining_looking_around_time = max(0.0, remaining_looking_around_time - delta)
		if remaining_looking_around_time <= 0.0:
			looking_around = false
	else: 
		move_if_needed(next_pos, speed)
		if enemy_state == EnemyState.ALERT:
			nav_agent.target_position = target.global_position
#			if !can_see_player():
#				if has_reached_point(chase_target):
#					chase_target = estimate_target_position()
#				nav_agent.target_position = chase_target
		elif enemy_state == EnemyState.SUSPICIOUS:
			if investigation_target != null && investigation_target is Vector3:
				nav_agent.target_position = investigation_target
				if has_reached_point(investigation_target):
					enemy_state = EnemyState.IDLE
					start_looking_around()
		elif enemy_state == EnemyState.IDLE:
			if !patrol_route.is_empty():
				var next_patrol_position = get_next_patrol_waypoint()
				if has_reached_point(next_patrol_position):
					look_at(global_position + facing_directions[current_patrol_index])
					current_patrol_index += 1
					start_looking_around()
				if next_patrol_position != null:
					nav_agent.target_position = next_patrol_position

func start_looking_around():
	looking_around = true
	remaining_looking_around_time = looking_around_time

func move_if_needed(next_pos: Vector3, amount: float):
	var dir = next_pos - global_position
	dir.y = 0.0
	if nav_agent.distance_to_target() > 0.05:
		if enemy_state == EnemyState.ALERT:
			amount *= alert_speed_mult
			anim_player.play("cat_run")
			cat.set_tail_motion_parameters(1.5, 1.0)
		else:
			anim_player.play("cat_walk")
			cat.set_tail_motion_parameters(1.0, 1.0)
		look_at(global_position + dir)
		velocity = dir.normalized() * amount
		move_and_slide()
		_process_collision()
	else:
		anim_player.play("cat_idle")

func _process_collision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		on_hit.emit(collider)

func estimate_target_position() -> Vector3:
	var rand_x = randf_range(-1.0, 1.0)
	var rand_z = randf_range(-1.0, 1.0)
	return target.global_position + Vector3(rand_x, 0.0, rand_z)

func keep_watch():
	if can_see_player():
		looking_around = false
		enemy_state = EnemyState.ALERT
		chase_target = target.global_position
	elif sound_heard != null && enemy_state != EnemyState.ALERT:
		looking_around = false
		enemy_state = EnemyState.SUSPICIOUS
		investigation_target = sound_heard
		sound_heard = null
	else:
		var item_in_sight = look_for_items()
		if item_in_sight != null:
			print("ITEM DETECTED")
			enemy_state = EnemyState.SUSPICIOUS
			investigation_target = item_in_sight.global_position
			item_in_sight.remove_from_group("ActiveItems")

#sound array is Array[[origin: Vector3, radius: float]]
func check_for_sounds(sound_array):
	for sound in sound_array:
		if global_position.distance_squared_to(sound[0]) < sound[1] * sound[1]:
			print("i hear you")

func has_reached_point(waypoint: Vector3) -> bool:
	return waypoint.distance_squared_to(global_position) < 0.3

func get_next_patrol_waypoint():
	if patrol_route.is_empty():
		return null
	if current_patrol_index >= patrol_route.size():
		current_patrol_index = 0
	if patrol_route.size() > current_patrol_index:
		return patrol_route[current_patrol_index]

func can_see_player() -> bool:
	if target != null:
		var angle_to_target = rad_to_deg(calculate_angle(target.global_position))
		if angle_to_target < vision_angle / 2.0:
			var collider_hit = cast_ray(target.global_position)
			if collider_hit != null:
				if collider_hit is CharacterBody3D:
					return true
				else:
					print("something in the way")
			else:
				print("nothing")
		else:
			print("angle")
	print("cant see")
	return false
	
func look_for_items():
	var level_items = get_tree().get_nodes_in_group("ActiveItems")
	for item in level_items:
		var angle_to_target = rad_to_deg(calculate_angle(item.global_position))
		if angle_to_target < vision_angle / 2.0:
			var collider_hit = cast_ray(item.global_position)
			if collider_hit != null:
				return item
	return null

func calculate_angle(_target: Vector3) -> float:
	var forward_pos = cat.facing_direction
	forward_pos.y = 0.0
	var direction_to_target = _target - global_position
	direction_to_target.y = 0.0
	return forward_pos.angle_to(direction_to_target)

func cast_ray(target: Vector3):
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position, target, 0b0011)
	var result = space_state.intersect_ray(query)
	if result:
		return result.collider

func set_overhead_label(text: String, color: Color):
	overhead_label.text = text
	overhead_label.modulate = color

func check_for_sound(origin: Vector3, strength: float):
	if target != null:
		if global_position.distance_to(origin) < strength:
			sound_heard = origin
