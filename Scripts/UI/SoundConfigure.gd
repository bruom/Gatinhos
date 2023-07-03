class_name SoundConfigure extends Object

var bgm_bus_index: int
var sfx_bus_index: int

func _init():
	bgm_bus_index = AudioServer.get_bus_index("BGM")
	sfx_bus_index = AudioServer.get_bus_index("SFX")

func get_bgm_audio_level() -> float:
	return _db_to_level(AudioServer.get_bus_volume_db(bgm_bus_index))
	
func set_bgm_audio_level(level: float):
	_change_audio_level(bgm_bus_index, level)

func get_sfx_audio_level() -> float:
	return _db_to_level(AudioServer.get_bus_volume_db(bgm_bus_index))

func set_sf_audio_level(level: float):
	_change_audio_level(sfx_bus_index, level)

func _change_audio_level(bus_index: int, level: float):
	AudioServer.set_bus_volume_db(bus_index, _level_to_db(level))
	
func _db_to_level(db: float) -> float:
	return ((db + 80) / 80) * 100
	
func _level_to_db(level: float) -> float:
	return  ((level / 100) * 80) - 80
	