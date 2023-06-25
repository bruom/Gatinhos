extends Node3D

@onready var loading: Loading = $Loading
@onready var scene_loader: SceneLoader = $SceneLoader

const ENEMY_COLLISION_LAYER = 0b0100
const PLAYER_COLLISION_LAYER = 0b0010

@export_range(1, 2) var current_level: int = 1
		
var current_scene: LevelBase

func _ready():
	scene_loader.scene_loaded.connect(Callable(show_level))
	scene_loader.scene_loading.connect(func(progress: float): loading.update_progress(progress))
	load_level(current_level)

func _process(_delta):
	pass

func show_level(scene: PackedScene):
	current_scene = scene.instantiate()
	current_scene.on_player_hit.connect(Callable(player_was_hit))
	current_scene.on_enemy_hit.connect(Callable(enemy_did_hit))
	current_scene.on_player_enter_finish_area.connect(Callable(player_did_finished))
	add_child(current_scene)
	loading.hide()

func load_level(number: int):
	if current_scene:
		current_scene.queue_free()
	loading.show()
	scene_loader.start_load_scene(number)

func player_did_finished():
	var next_level = 1 if current_level == 2 else 2
	current_level = next_level
	load_level(next_level)
	print("WOW! SUCH WIN!")

func enemy_did_hit(collider):
	if collider.collision_layer == PLAYER_COLLISION_LAYER:
		current_scene.get_tree().reload_current_scene()

func player_was_hit(collider):
	if collider.collision_layer == ENEMY_COLLISION_LAYER:
		current_scene.get_tree().reload_current_scene()
		print("GAME OVER MERMÃO!")
