class_name ConfigurationUI extends Control

signal back_button_pressed

@onready var back_button: Button = $HSplitContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/BackButton

@onready var bgm_slider: SliderEntry = $HSplitContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/bgm
@onready var sfx_slider: SliderEntry = $HSplitContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/sfx

var sound_configure: SoundConfigure = SoundConfigure.new()

func _ready():
	
	back_button.button_up.connect(func(): back_button_pressed.emit())
	
	bgm_slider.set_slider_value(sound_configure.get_bgm_audio_level())
	sfx_slider.set_slider_value(sound_configure.get_sfx_audio_level())
	bgm_slider.value_changed.connect(Callable(sound_configure.set_bgm_audio_level))
	sfx_slider.value_changed.connect(Callable(sound_configure.set_bgm_audio_level))
