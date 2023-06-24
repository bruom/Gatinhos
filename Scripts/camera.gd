extends Camera3D

@export var isDebugModeEnabled: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_cull_mask_value(10, isDebugModeEnabled)
