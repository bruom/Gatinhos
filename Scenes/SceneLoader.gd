class_name SceneLoader extends Node3D

signal scene_loaded(scene: PackedScene)
signal scene_loading(progress: float)

var isLoadingScene: bool = true
var loadingPath: String = ""

func _process(delta):
	if isLoadingScene:
		var progress: Array[float] = []
		var status = ResourceLoader.load_threaded_get_status(loadingPath, progress)
		print("loading ", loadingPath, ": ", [progress[0]])
		scene_loading.emit(progress[0])
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			isLoadingScene = false
			var scene = ResourceLoader.load_threaded_get(loadingPath)
			scene_loaded.emit(scene)

func get_scene() -> PackedScene:
	return ResourceLoader.load_threaded_get(loadingPath)
	
func start_load_scene(level: int):
	var filePath = "res://Scenes/Levels/level%02d.tscn"
	var fullPath = filePath % [level]
	ResourceLoader.load_threaded_request(fullPath, "PackedScene")
	loadingPath = fullPath
	isLoadingScene = true
