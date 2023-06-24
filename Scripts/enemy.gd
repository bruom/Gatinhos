extends Node3D

@onready var nav_agent: NavigationAgent3D = $nav_agent

@export var target: Node3D
@export var alert_material: Material
@export var speed: float = 1.0
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
	
	if enemy_state == EnemyState.ALERT:
		nav_agent.target_position = target.global_position
		var dir = next_pos - global_position
		global_position += dir.normalized() * speed * delta
	else:
		if target != null:
			var angle_to_target = rad_to_deg(calculate_angle(target.global_position))
			if angle_to_target < 45.0:
				var collider_hit = cast_ray(target.global_position)
				if collider_hit != null:
					if collider_hit is CharacterBody3D:
						enemy_state = EnemyState.ALERT
						mesh_instance.set_surface_override_material(0, alert_material)

func calculate_angle(target: Vector3) -> float:
	var forward_pos = to_local(position + Vector3.FORWARD)
	var direction_to_target = target - global_position
	return forward_pos.angle_to(direction_to_target)

func cast_ray(target: Vector3):
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position, target, 0b0011)
	var result = space_state.intersect_ray(query)
	if result:
		return result.collider
