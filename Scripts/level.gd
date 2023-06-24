extends Node3D

@onready var navigation_region_3d = $NavigationRegion3D

var currentLevel: int = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var filePath = "res://Scenes/Levels/level%02d.tscn"
	var fullPath = filePath % [currentLevel]
	var scene: PackedScene = load(filePath % [currentLevel])
	var node = scene.instantiate()
	add_child(node)

	navigation_region_3d.navigation_mesh.geometry_source_group_name = "level_mesh_region";
	navigation_region_3d.bake_navigation_mesh()
	
