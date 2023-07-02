class_name SliderEntry extends HBoxContainer

signal value_changed(float)

@export var label_content: String

@onready var label: Label = $Label
@onready var slider: Slider = $slider

# Called when the node enters the scene tree for the first time.
func _ready():
	slider.value_changed.connect(func(value): value_changed.emit(value_changed))
	label.text = tr(label_content)
