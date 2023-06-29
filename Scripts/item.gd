extends InteractibleObject

enum ItemType {
	Toy = 1, Catnip = 2
}
@export var item_type: ItemType = 1
var player: CharacterBody3D
var active = false

func _ready():
	super._ready()
	interaction_hint = "PICK UP"

func interaction_completed():
	print("Item collected")
	#player.pickup_item(self)
	self.queue_free()

func _on_hitbox_body_entered(body):
	if "enemy" in body.name && self.active:
		body.trigger_item(item_type)
		remove_from_group("ActiveItems")
		self.queue_free()

func item_placed():
	if self.active:
		print("Item placed: " + str(item_type))
		add_to_group("ActiveItems")
		if item_type == 1:
			get_node("Hitbox/ItemMesh").mesh.material.albedo_color = Color(0, 0, 255, 255)
		elif item_type == 2:
			get_node("Hitbox/ItemMesh").mesh.material.albedo_color = Color(0, 255, 0, 255)

