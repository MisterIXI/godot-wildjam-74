class_name Interactable
extends StaticBody2D

signal interacted

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "default"

func _ready() -> void:
	if get_child_count() > 0:
		for child in get_children():
			if child is CollisionShape2D:
				child.z_index = 10
				child.debug_color = Color.SALMON

func interact() -> void:
	if dialogue_resource == null:
		printerr("No Dialogue Resource attached!")
		return
	interacted.emit()
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)
