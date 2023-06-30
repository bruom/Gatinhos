class_name Soundwave extends MeshInstance3D

@export var noise_strength = 1.0

var current_scale = 0.0;
var isPlaying = false
var multiplier = 0.0;

func _process(delta):
	if current_scale > noise_strength * 2:
		queue_free()
	
	if isPlaying:
		current_scale += delta * multiplier;
		scale = Vector3(current_scale, 1.0, current_scale)
	
func play():
	if noise_strength <= 0:
		queue_free()
	else:
		current_scale = 0.0
		multiplier = noise_strength * 6
		isPlaying = true
