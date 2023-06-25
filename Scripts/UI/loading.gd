class_name Loading extends Control

func update_progress(progress: float):
	$ColorRect/VBoxContainer/HBoxContainer/ProgressBar.value = progress
