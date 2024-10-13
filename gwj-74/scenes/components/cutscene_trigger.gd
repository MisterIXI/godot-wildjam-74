extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "default"


func action() -> void:
	if dialogue_resource == null:
		printerr("No Dialogue Resource attached!")
		return
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)
	
