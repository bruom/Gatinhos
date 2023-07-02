class_name ConfigurationUI extends Control

signal back_button_pressed

@onready var back_button: Button = $HSplitContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/BackButton

@onready var bgm_slider: SliderEntry = $HSplitContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/bgm
@onready var sfx_slider: SliderEntry = $HSplitContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/sfx

var bgm_bus_index: int
var sfx_bus_index: int

func _ready():
	back_button.button_up.connect(func(): back_button_pressed.emit())
	
	bgm_bus_index = AudioServer.get_bus_index("BGM")
	sfx_bus_index = AudioServer.get_bus_index("SFX")
	
	var volume = AudioServer.get_bus_volume_db(bgm_bus_index)
	bgm_slider.set_slider_value(_db_to_level(volume))
	
	volume = AudioServer.get_bus_volume_db(sfx_bus_index)
	sfx_slider.set_slider_value(_db_to_level(volume))
	
	bgm_slider.value_changed.connect(Callable(_bgm_audio_level_changed))
	sfx_slider.value_changed.connect(Callable(_sfx_audio_level_changed))

func _bgm_audio_level_changed(level: float):
	_change_audio_level(bgm_bus_index, level)

func _sfx_audio_level_changed(level: float):
	_change_audio_level(sfx_bus_index, level)

func _change_audio_level(bus_index: int, level: float):
	AudioServer.set_bus_volume_db(bus_index, _level_to_db(level))
	
func _db_to_level(db: float) -> float:
	return ((db + 80) / 80) * 100
	
func _level_to_db(level: float) -> float:
	return  ((level / 100) * 80) - 80
