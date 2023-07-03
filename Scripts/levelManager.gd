extends Node3D

@onready var loading: Loading = $Loading
@onready var gui = $gui
@onready var scene_loader: SceneLoader = $SceneLoader
@onready var pause_gui: PauseGUI = $PauseGUI
@onready var background_music_player: AudioStreamPlayer = $BackgroundMusicPlayer

@export var main_menu_scene: PackedScene

const ENEMY_COLLISION_LAYER = 0b0100
const PLAYER_COLLISION_LAYER = 0b0010

@export_range(1, 2) var current_level: int = 1
		
var current_scene: LevelBase

func _ready():
	scene_loader.scene_loaded.connect(Callable(show_level))
	scene_loader.scene_loading.connect(func(progress: float): loading.update_progress(progress))
	gui.pause_button_pressed.connect(Callable(pause_menu))
	pause_gui.button_pressed.connect(Callable(pause_menu_button_pressed))
	pause_gui.hide()
	load_level(current_level)

func show_level(scene: PackedScene):
	current_scene = scene.instantiate()
	current_scene.on_player_hit.connect(Callable(player_was_hit))
	current_scene.on_enemy_hit.connect(Callable(enemy_did_hit))
	current_scene.on_player_enter_finish_area.connect(Callable(player_did_finished))
	current_scene.on_item_amount_change.connect(Callable(item_amount_did_change))
	current_scene.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(current_scene)
	background_music_player.stream = current_scene.background_music
	background_music_player.play()
	print(current_scene)
	loading.hide()
	gui.show()

func load_level(number: int):
	if current_scene:
		current_scene.queue_free()
	loading.show()
	gui.hide()
	scene_loader.start_load_scene(number)

func item_amount_did_change(new_amount: int):
	gui.set_amount(new_amount)

func player_did_finished():
	var next_level = 1 if current_level == 2 else 2
	current_level = next_level
	load_level(next_level)

func enemy_did_hit(collider):
	if collider.collision_layer == PLAYER_COLLISION_LAYER:
		current_scene.get_tree().reload_current_scene()

func player_was_hit(collider):
	if collider.collision_layer == ENEMY_COLLISION_LAYER:
		current_scene.get_tree().reload_current_scene()

func pause_menu():
	get_tree().paused = true
	pause_gui.show()
	
func pause_menu_button_pressed(option: PauseGUI.Option):
	if option == PauseGUI.Option.TITLE:
		get_tree().change_scene_to_packed(main_menu_scene)
	elif option == PauseGUI.Option.RESUME:
		get_tree().paused = false
		pause_gui.hide()
