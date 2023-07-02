class_name Menu extends Node3D

@onready var menu_ui: MainMenuUI = $MainMenuUI
@onready var configuration_ui: ConfigurationUI = $configuration

@export var level_manager: PackedScene

func _ready():
	menu_ui.option_selected.connect(Callable(selected))
	configuration_ui.hide()
	configuration_ui.back_button_pressed.connect(Callable(_back_to_main_menu))

func selected(option: MainMenuUI.Option):
	
	if option == MainMenuUI.Option.START:
		var manager = level_manager.instantiate()
		get_tree().change_scene_to_packed(level_manager)
	elif option == MainMenuUI.Option.CONFIG:
		menu_ui.hide()
		configuration_ui.show()
	elif option == MainMenuUI.Option.CREDITS:
		pass
	elif option == MainMenuUI.Option.EXIT:
		get_tree().quit()

func _back_to_main_menu():
	configuration_ui.hide()
	menu_ui.show()
