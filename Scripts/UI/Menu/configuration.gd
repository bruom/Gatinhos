class_name ConfigurationUI extends Control

signal back_button_pressed

@onready var back_button: Button = $HSplitContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/BackButton

# Called when the node enters the scene tree for the first time.
func _ready():
	back_button.button_up.connect(func(): back_button_pressed.emit())
