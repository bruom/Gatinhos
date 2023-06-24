extends Node3D


func open_door():
	get_node("AnimationPlayer").play("Open")
