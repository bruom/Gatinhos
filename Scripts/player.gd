extends CharacterBody3D

@export var speed: float = 1.0

func _process(delta):
	var direciton: Vector2 = Input.get_vector("Left", "Right", "Forward", "Backward")
	velocity = Vector3(direciton.x, 0.0, direciton.y).normalized() * speed
	if velocity != Vector3.ZERO:
		look_at(global_position + velocity)
		move_and_slide()
