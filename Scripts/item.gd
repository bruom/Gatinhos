extends InteractibleObject

signal on_item_pickup(item_id)

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
	on_item_pickup.emit(item_type)
	self.queue_free()

func _on_hitbox_body_entered(body):
	if "enemy" in body.name && self.active:
		body.trigger_item(item_type)
		remove_from_group("ActiveItems")
		self.queue_free()

func item_placed():
	if self.active:
		add_to_group("ActiveItems")

