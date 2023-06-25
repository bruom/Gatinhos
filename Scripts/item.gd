class_name Item extends Node3D

enum ItemType {
	Toy = 1, Catnip = 2
}
@export var item_type: ItemType = 1
var player: CharacterBody3D
var interactable = false
var active = false

func _input(event):
	if interactable && event.is_action_pressed("Interact"):
		print("Item collected")
		player.pickup_item(self)
		self.queue_free()

func _on_hitbox_body_entered(body):
	if body.name == "Player":
		interactable = true
		player = body
		
func _on_hitbox_body_exited(body):
	if body.name == "Player":
		interactable = false

func item_effect():
	if active:
		print("Item in effect: " + str(item_type))
		add_to_group("ActiveItems")
		if item_type == 1:
			return
		elif item_type == 2:
			return

