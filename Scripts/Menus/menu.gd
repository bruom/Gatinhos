class_name Menu extends Node3D

@onready var menu_ui: MainMenuUI = $MainMenuUI

@export var level_manager: PackedScene

func _ready():
	menu_ui.option_selected.connect(Callable(selected))

func selected(option: MainMenuUI.Option):
	
	if option == MainMenuUI.Option.START:
		var manager = level_manager.instantiate()
		get_tree().change_scene_to_packed(level_manager)
	elif option == MainMenuUI.Option.CONFIG:
		pass
	elif option == MainMenuUI.Option.CREDITS:
		pass
	elif option == MainMenuUI.Option.EXIT:
		get_tree().quit()
