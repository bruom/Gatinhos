extends Node3D

var interactable = false
var open = false

func _process(delta):
	if interactable && !open && Input.is_action_pressed("Interact"):
		self.open_door()

func _on_interaction_range_body_entered(body):
	if body.name == "Player":
		interactable = true

func _on_interaction_range_body_exited(body):
	if body.name == "Player":
		interactable = false

func open_door():
	get_node("AnimationPlayer").play("Open")
	interactable = false
	open = true
