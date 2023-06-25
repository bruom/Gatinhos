extends Node3D

signal sound_emitted

const ENEMY_COLLISION_LAYER = 0b0100

@export_range(1,2) var current_level: int:
	set(level):
		current_level = level
		load_scene()
		
var current_scene: LevelBase

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func register_sound_source(source, point, radius):
	sound_emitted.emit(point, radius)

func load_scene():
	if current_scene:
		current_scene.queue_free()
		
	var filePath = "res://Scenes/Levels/level%02d.tscn"
	var fullPath = filePath % [current_level]
	var scene: PackedScene = load(filePath % [current_level])
	current_scene = scene.instantiate()
	current_scene.on_player_hit.connect(Callable(player_was_hit))
	current_scene.on_player_enter_finish_area.connect(Callable(player_did_finished))
	add_child(current_scene)

func player_did_finished():
	var next_level = 1 if current_level == 2 else 2
	current_level = next_level
	print("WOW! SUCH WIN!")

func player_was_hit(collider):
	if collider.collision_layer == ENEMY_COLLISION_LAYER:
		print("GAME OVER MERMÃO!")
