extends Node

@export var normal_balloon_path : String = "res://scenes/dialogue/balloon.tscn"
@export var color_screen_balloon_path : String = "res://scenes/dialogue/color_screen_balloon.tscn"


func _ready() -> void:
	set_balloon(false)


func set_balloon(is_color_screen : bool) -> void:
	if is_color_screen:
		DialogueManager.DialogueSettings.set_setting(&"balloon_path", color_screen_balloon_path, false)
	else:
		DialogueManager.DialogueSettings.set_setting(&"balloon_path", normal_balloon_path, false)