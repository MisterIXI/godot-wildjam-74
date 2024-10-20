extends Node2D
class_name Main
@onready var deserted_subway_sfx: AudioStreamPlayer = %DesertedSubway
@onready var creepy_ghost: AudioStreamPlayer = $SFX/CreepyGhost
@onready var creepy_sound: AudioStreamPlayer = $SFX/CreepySound
@onready var locked_door: AudioStreamPlayer = $SFX/LockedDoor
@onready var unlock_door: AudioStreamPlayer = $SFX/UnlockDoor
@onready var key_rattle: AudioStreamPlayer = $SFX/KeyRattle


@onready var environment: xXxEnvironmentxXx = %Environment
@onready var player: Player = %player
@onready var padlock: Padlock = %Padlock
@onready var color_screen: ColorScreen = %ColorScreen

func set_dialogue_auto_skip(value : bool) -> void:
	DialogueManager.auto_skip = value
