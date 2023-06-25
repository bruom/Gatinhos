class_name NoiseEmitter extends Node3D

signal noise_emitted(origin: Vector3, strength: float)

@export var noise_audio_stream: AudioStream
@onready var audio_player = $AudioStreamPlayer3D

#@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

func emit_noise(strength: float = 1):
	noise_emitted.emit(global_position, strength)
	play_sound()
	
#	var shape = CylinderMesh.new()
#	var material = StandardMaterial3D.new()
#	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
#	material.albedo_color = Color(0, 1, 0, 0.5)
#	shape.height = 0.1
#	shape.top_radius = strenght
#	shape.bottom_radius = strenght
#	shape.material = material
#	mesh_instance_3d.mesh = shape
#	mesh_instance_3d.show()
#	var timer = Timer.new()
#	timer.one_shot = true
#	timer.timeout.connect(func():
#		mesh_instance_3d.hide()
#	)
#	add_child(timer)
#	timer.start(0.2)
	
func play_sound():
	if !noise_audio_stream: return
	var audioPlayer: AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	audioPlayer.stream = noise_audio_stream
	audioPlayer.finished.connect(func(): audioPlayer.queue_free())
	add_child(audioPlayer)
	audioPlayer.play()
	
