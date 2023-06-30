extends Control

@onready var item_amount = $Panel/HBoxContainer/item_amount

func set_amount(new_amount: int):
	item_amount.text = str(new_amount)
