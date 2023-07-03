extends Control

signal pause_button_pressed

@onready var item_amount = $Panel/HBoxContainer/item_amount
@onready var button: Button = $Panel2/Button

func _ready():
	button.button_up.connect(Callable(func(): pause_button_pressed.emit()))

func set_amount(new_amount: int):
	item_amount.text = str(new_amount)
