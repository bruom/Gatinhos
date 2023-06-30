class_name NoiseEmitter extends Node3D

signal noise_emitted(origin: Vector3, strength: float)

@export var noise_audio_stream: AudioStream

func emit_noise(strength: float = 1):
	noise_emitted.emit(global_position, strength)
	play_sound()
#	create_debug_range(strength)

func create_debug_range(strength: float):
	var mesh_instance_3d: MeshInstance3D = MeshInstance3D.new()
	var shape = CylinderMesh.new()
	var material = StandardMaterial3D.new()
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = Color(0, 1, 0, 0.5)
	shape.height = 0.1
	shape.top_radius = strength
	shape.bottom_radius = strength
	shape.material = material
	mesh_instance_3d.mesh = shape
	var timer = Timer.new()
	timer.one_shot = true
	
	add_child(mesh_instance_3d)
	timer.timeout.connect(func():
		mesh_instance_3d.queue_free()
	)
	add_child(timer)
	timer.start(0.2)
	
func play_sound():
	if !noise_audio_stream: return
	var audioPlayer: AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	audioPlayer.stream = noise_audio_stream
	audioPlayer.finished.connect(func(): audioPlayer.queue_free())
	add_child(audioPlayer)
	audioPlayer.play()
	
