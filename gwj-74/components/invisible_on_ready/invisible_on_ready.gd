extends Node
class_name InvisibleOnReady

func _ready() -> void:
	get_parent().hide()
