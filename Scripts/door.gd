extends InteractibleObject

var open = false

func interaction_completed():
	get_node("AnimationPlayer").play("Open")
	interaction_enabled = false
	open = true
