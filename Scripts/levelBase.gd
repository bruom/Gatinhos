class_name LevelBase extends Node3D

@export var player: PackedScene

var playerNode: Node3D
# Called when the node enters the scene tree for the first time.
func _ready():
	
	playerNode = player.instantiate()
	add_child(playerNode)
	playerNode.position = $PlayerStart.position
	
	var enemyNodes = $Enemies.get_children()
	for enemy in enemyNodes:
		enemy.target = playerNode
	
	var finishID = $LevelMap.mesh_library.find_item_by_name("Finish")
	var finishes = $LevelMap.get_used_cells_by_item(finishID)
	for finishGridPosition in finishes:
		
		var area = Area3D.new()
		var collision3D = CollisionShape3D.new()
		collision3D.shape = BoxShape3D.new()
		area.add_child(collision3D)
		area.set_collision_layer_value(0b0001, true)
		area.body_entered.connect(Callable(self, "player_entered_finish_tile"))
		add_child(area)
		area.position = Vector3(finishGridPosition.x, finishGridPosition.y, finishGridPosition.z) + Vector3(0.5, 0.5, 0.5)
		
		area.set_collision_mask_value(1, false)
		area.set_collision_mask_value(2, true)
		
		$LevelMap.set_cell_item(finishGridPosition, -1)
	

func player_entered_finish_tile(node):
	if node == playerNode:
		print("WOW!")	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
