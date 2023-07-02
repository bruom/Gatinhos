class_name SliderEntry extends HBoxContainer

signal value_changed(float)

@export var label_content: String

@onready var label: Label = $Label
@onready var slider: Slider = $slider

func _ready():
	slider.value_changed.connect(func(value): value_changed.emit(value))
	label.text = tr(label_content)

func set_slider_value(value: float):
	slider.value = value
