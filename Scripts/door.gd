extends InteractibleObject

var open = false

func _ready():
	super._ready()
	interaction_hint = "OPEN"

func interaction_completed():
	get_node("AnimationPlayer").play("Open")
	interaction_enabled = false
	open = true
