class_name PauseGUI extends Control

signal button_pressed(Option)

enum Option {
	TITLE,
	RESUME
}

@onready var bgm_slider: SliderEntry = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/BGMSlider
@onready var sfx_slider: SliderEntry = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/SFXSlider

@onready var title_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/TitleButton
@onready var resume_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ResumeButton

var sound_configure: SoundConfigure = SoundConfigure.new()

func _ready():

	bgm_slider.set_slider_value(sound_configure.get_bgm_audio_level())
	sfx_slider.set_slider_value(sound_configure.get_sfx_audio_level())
	bgm_slider.value_changed.connect(Callable(sound_configure.set_bgm_audio_level))
	sfx_slider.value_changed.connect(Callable(sound_configure.set_bgm_audio_level))
	
	title_button.button_up.connect(Callable(func(): button_pressed.emit(Option.TITLE)))
	resume_button.button_up.connect(Callable(func(): button_pressed.emit(Option.RESUME)))
