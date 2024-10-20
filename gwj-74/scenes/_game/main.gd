extends Node2D
class_name Main
@onready var deserted_subway_sfx: AudioStreamPlayer = %DesertedSubway
@onready var environment: xXxEnvironmentxXx = %Environment
@onready var player: Player = %player


func set_dialogue_auto_skip(value : bool) -> void:
	DialogueManager.auto_skip = value
