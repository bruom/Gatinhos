extends Node3D

@onready var nav_agent: NavigationAgent3D = $nav_agent

@export var target: Node3D
@export var alert_material: Material
@export var vision_angle: float = 60
@export var speed: float = 1.0
@export var patrol_route: Array[Vector3] = []
var current_patrol_index: int = 0
var mesh_instance: MeshInstance3D
var enemy_state: EnemyState = EnemyState.IDLE
var last_known_enemy_position: Vector3

enum EnemyState {
	IDLE,
	SUSPICIOUS,
	ALERT
}

func _ready():
	mesh_instance = get_node("StaticBody3D/cat/mesh")
	
func _process(delta):
	var next_pos = nav_agent.get_next_path_position()
	var dir = next_pos - global_position
	if dir != Vector3.ZERO:
		look_at(next_pos)
		global_position += dir.normalized() * speed * delta
	
	if enemy_state == EnemyState.ALERT:
		nav_agent.target_position = target.global_position
	elif enemy_state == EnemyState.IDLE:
		if can_see_player():
			enemy_state = EnemyState.ALERT
			mesh_instance.set_surface_override_material(0, alert_material)
		var next_patrol_position = get_next_patrol_waypoint()
		if has_arrived_at_waypoint(next_patrol_position):
			current_patrol_index += 1
		if next_patrol_position != null:
			nav_agent.target_position = next_patrol_position
			

func has_arrived_at_waypoint(waypoint: Vector3) -> bool:
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