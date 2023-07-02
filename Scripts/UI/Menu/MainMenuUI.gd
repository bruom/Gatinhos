class_name MainMenuUI extends Control

signal option_selected(Option)

enum Option {
	START,
	CONFIG,
	CREDITS,
	EXIT
}

@onready var start_button: Button = $MarginContainer/CenterContainer/Panel/MarginContainer/VBoxContainer/StartButton
@onready var config_button: Button = $MarginContainer/CenterContainer/Panel/MarginContainer/VBoxContainer/ConfigButton
@onready var credits_button: Button = $MarginContainer/CenterContainer/Panel/MarginContainer/VBoxContainer/CreditsButton
@onready var exit_button: Button = $MarginContainer/CenterContainer/Panel/MarginContainer/VBoxContainer/ExitButton

func _ready():
	start_button.button_up.connect(func(): option_selected.emit(Option.START))
	config_button.button_up.connect(func(): option_selected.emit(Option.CONFIG))
	credits_button.button_up.connect(func(): option_selected.emit(Option.CREDITS))
	exit_button.button_up.connect(func(): option_selected.emit(Option.EXIT))
