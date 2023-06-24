extends Node3D

@onready var char_body: CharacterBody3D = $char_body

func _process(delta):
	var direciton: Vector2 = Input.get_vector("Left", "Right", "Forward", "Backward")
	char_body.velocity = Vector3(direciton.x, 0.0, direciton.y)
	char_body.move_and_slide()
