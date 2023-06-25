extends Node3D

@onready var nav_agent: NavigationAgent3D = $nav_agent

@export var target: Node3D
@export var alert_material: Material
@export var suspicious_material: Material
@export var vision_angle: float = 60
@export var speed: float = 1.0
@export var investigation_time: float = 2.5
@export var patrol_route: Array[Vector3] = []

var current_patrol_index: int = 0
var mesh_instance: MeshInstance3D
var enemy_state: EnemyState = EnemyState.IDLE:
	set(value):
		enemy_state = value
		if value == EnemyState.SUSPICIOUS:
			mesh_instance.set_surface_override_material(0, suspicious_material)
		elif value == EnemyState.ALERT:
			mesh_instance.set_surface_override_material(0, alert_material)
		else:
			mesh_instance.set_surface_override_material(0, null)

var chase_target
var investigation_target
var remaining_investigation_time: float = 0.0
var investigating: bool = false

enum EnemyState {
	IDLE,
	SUSPICIOUS,
	ALERT
}

func _ready():
	mesh_instance = get_node("StaticBody3D/cat/mesh")
	
func _physics_process(delta):
	var next_pos = nav_agent.get_next_path_position()
	move_if_needed(next_pos, speed * delta)
	
	keep_watch()
	if investigating:
		remaining_investigation_time = max(0.0, remaining_investigation_time - delta)
		if remaining_investigation_time <= 0.0:
			investigating = false
	else: 
		if enemy_state == EnemyState.ALERT:
			if !can_see_player():
				if has_reached_point(chase_target):
					chase_target = estimate_target_position()
				nav_agent.target_position = chase_target
		elif enemy_state == EnemyState.SUSPICIOUS:
			if investigation_target != null && investigation_target is Vector3:
				nav_agent.target_position = investigation_target
				if has_reached_point(investigation_target):
					enemy_state = EnemyState.IDLE
					investigating = true
					remaining_investigation_time = investigation_time
		elif enemy_state == EnemyState.IDLE:
			if !patrol_route.is_empty():
				var next_patrol_position = get_next_patrol_waypoint()
				if has_reached_point(next_patrol_position):
					current_patrol_index += 1
				if next_patrol_position != null:
					nav_agent.target_position = next_patrol_position

func move_if_needed(next_pos: Vector3, amount: float):
	var dir = next_pos - global_position
	if dir.length() > 0.1:
		look_at(next_pos)
		global_position += dir.normalized() * amount

func estimate_target_position() -> Vector3:
	var rand_x = randf_range(-1.0, 1.0)
	var rand_z = randf_range(-1.0, 1.0)
	return target.global_position + Vector3(rand_x, 0.0, rand_z)

func keep_watch():
	if can_hear_player() && enemy_state != EnemyState.ALERT:
		enemy_state = EnemyState.SUSPICIOUS
		investigation_target = target.global_position
	if can_see_player():
		enemy_state = EnemyState.ALERT
		chase_target = target.global_position

#sound array is Array[[origin: Vector3, radius: float]]
func check_for_sounds(sound_array):
	for sound in sound_array:
		if global_position.distance_squared_to(sound[0]) < sound[1] * sound[1]:
			print("i hear you")

func can_hear_player() -> bool:
	if target != null:
		if global_position.distance_to(target.global_position) < target.current_sound_radius:
			return true
	return false

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
	return false

func calculate_angle(target: Vector3) -> float:
	var forward_pos = -global_transform.basis.z
	var direction_to_target = target - global_position
	return forward_pos.angle_to(direction_to_target)

func cast_ray(target: Vector3):
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position, target, 0b0011)
	var result = space_state.intersect_ray(query)
	if result:
		return result.collider
