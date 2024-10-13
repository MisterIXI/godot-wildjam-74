class_name Interactable
extends StaticBody2D

signal interacted

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "default"


func interact() -> void:
	if dialogue_resource == null:
		printerr("No Dialogue Resource attached!")
		return
	interacted.emit()
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)
