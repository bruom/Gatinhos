extends Node3D

var interactable = false

func _process(delta):
	if interactable && Input.is_action_pressed("Interact"):
		self.open_door()

func _on_interaction_range_body_entered(body):
	interactable = true

func _on_interaction_range_body_exited(body):
	interactable = false

func open_door():
	get_node("AnimationPlayer").play("Open")
