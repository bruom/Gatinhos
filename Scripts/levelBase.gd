class_name LevelBase extends Node3D

@export var playerScene: PackedScene
@export var doorScene: PackedScene
@export var background_music: AudioStream

var playerNode: Node3D 

# Called when the node enters the scene tree for the first time.
func _ready():
	_create_player()
	_create_enemy_nodes()
	_create_finish_nodes()
	_create_door_nodes()
	
	$NavigationRegion3D.navigation_mesh.geometry_source_group_name = "level_mesh_region";
	$NavigationRegion3D.bake_navigation_mesh()
	
	$AudioStreamPlayer.stream = background_music
	$AudioStreamPlayer.play()
		
func _create_player():
	playerNode = playerScene.instantiate()
	add_child(playerNode)
	playerNode.position = $PlayerStart.position
	
func _create_enemy_nodes():
	var enemyNodes = $Enemies.get_children()
	for enemy in enemyNodes:
		enemy.target = playerNode
	

func _create_finish_nodes():
	var id = $LevelMap.mesh_library.find_item_by_name("Finish")
	var finishPositions = $LevelMap.get_used_cells_by_item(id)
	for finishGridPosition in finishPositions:
		
		var area = Area3D.new()
		var collision3D = CollisionShape3D.new()
		collision3D.shape = BoxShape3D.new()
		area.add_child(collision3D)
		area.set_collision_layer_value(0b0001, true)
		area.body_entered.connect(Callable(self, "player_entered_finish_tile"))
		add_child(area)
		area.position = grid_to_scene_position(finishGridPosition)
		
		area.set_collision_mask_value(1, false)
		area.set_collision_mask_value(2, true)
		
		$LevelMap.set_cell_item(finishGridPosition, -1)
		
#		var meshInstance = MeshInstance3D.new()
#		meshInstance.mesh = BoxMesh.new()
#		area.add_child(meshInstance)

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
	door.position = grid_to_scene_position(gridPosition, Vector3(0.5, 0, 0.5))
	door.rotation.y = rotation
	
func player_entered_finish_tile(node):
	if node == playerNode:
		print("WOW!")	

func grid_to_scene_position(gridPosition, offset = Vector3(0.5, 0.5, 0.5)) -> Vector3:
	return Vector3(gridPosition.x, gridPosition.y, gridPosition.z) + offset

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
