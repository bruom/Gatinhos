class_name LevelBase extends Node3D

signal on_player_hit(collider)
signal on_enemy_hit(collider)
signal on_player_enter_finish_area
signal noise_emitted(node: Node3D, origin: Vector3, strength: float)

@export var playerScene: PackedScene
@export var doorScene: PackedScene
@export var soundwave_scene: PackedScene
@export var background_music: AudioStream

var playerNode: Player 

# Called when the node enters the scene tree for the first time.
func _ready():
	_create_player()
	_create_enemy_nodes()
	_create_finish_nodes()
	_create_door_nodes()
	_create_collisions()
	
	$AudioStreamPlayer.stream = background_music
	$AudioStreamPlayer.play()

func _create_collisions():
	var id = $LevelMap.mesh_library.find_item_by_name("Wall")
	var wallPositions = $LevelMap.get_used_cells_by_item(id)
	for wallPosition in wallPositions:
		_create_collision_box(wallPosition)

func _create_player():
	playerNode = playerScene.instantiate()
	add_child(playerNode)
	
	playerNode.position = $PlayerStart.position
	playerNode.on_hit.connect(func(collider): on_player_hit.emit(collider))
	playerNode.noise_emitter.noise_emitted.connect(func(origin: Vector3, strength: float): _create_sound_wave(origin, strength))

func _create_enemy_nodes():
	var enemyNodes = $Enemies.get_children()
	for enemy in enemyNodes:
		enemy.target = playerNode
		playerNode.noise_emitter.noise_emitted.connect(Callable(enemy, "check_for_sound"))
		enemy.on_hit.connect(func(collider): on_enemy_hit.emit(collider))

func _create_finish_nodes():
	var id = $LevelMap.mesh_library.find_item_by_name("Finish")
	var finishPositions = $LevelMap.get_used_cells_by_item(id)
	for finishGridPosition in finishPositions:
		
		var area = Area3D.new()
		var collision3D = CollisionShape3D.new()
		collision3D.shape = BoxShape3D.new()
		
		area.add_child(collision3D)
		area.set_collision_layer_value(0b0001, true)
		area.set_collision_mask_value(0b0001, false)
		area.set_collision_mask_value(0b0010, true)
		
		area.body_entered.connect(func(node): if node is Player: on_player_enter_finish_area.emit())
		
		add_child(area)
		
		area.position = _grid_to_scene_position(finishGridPosition)
		
		$LevelMap.set_cell_item(finishGridPosition, -1)
		
		var meshInstance = MeshInstance3D.new()
		meshInstance.mesh = BoxMesh.new()
		area.add_child(meshInstance)

func _create_door_nodes():
	var id = $LevelMap.mesh_library.find_item_by_name("DoorX")
	var doorPositions = $LevelMap.get_used_cells_by_item(id)
	for doorGridPosition in doorPositions:
		_create_door(doorGridPosition)
		$LevelMap.set_cell_item(doorGridPosition, -1)
		
	id = $LevelMap.mesh_library.find_item_by_name("DoorZ")
	doorPositions = $LevelMap.get_used_cells_by_item(id)
	for doorGridPosition in doorPositions:
		_create_door(doorGridPosition, deg_to_rad(90))
		$LevelMap.set_cell_item(doorGridPosition, -1)

func _create_door(gridPosition, rotation = 0):
	var door = doorScene.instantiate()
	add_child(door)
	door.position = _grid_to_scene_position(gridPosition, Vector3(0.5, 0, 0.5))
	door.rotation.y = rotation

func _create_collision_box(grid_position):
	var col = CollisionShape3D.new()
	var body = StaticBody3D.new()
	col.shape = BoxShape3D.new()
	body.add_child(col)
	$Collisions.add_child(body)
	col.position = _grid_to_scene_position(grid_position)

func _grid_to_scene_position(gridPosition, offset = Vector3(0.5, 0.5, 0.5)) -> Vector3:
	return Vector3(gridPosition.x, gridPosition.y, gridPosition.z) + offset

func _create_sound_wave(origin: Vector3, strength: float):
	var soundwave_node: Soundwave = soundwave_scene.instantiate()
	add_child(soundwave_node)
	soundwave_node.global_position = Vector3(origin.x, origin.y + 0.1, origin.z)
	soundwave_node.noise_strength = strength
	soundwave_node.play()
