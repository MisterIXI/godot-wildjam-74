extends AudioStreamPlayer
class_name AudioStreamSelector

var _sibling : DialogueResponsesMenu = null


func _ready() -> void:
	for sibling in get_parent().get_children():
		if sibling is DialogueResponsesMenu:
			_sibling = sibling
			break
	_sibling.response_selected.connect(_on_response_selected)


func _on_response_selected(_response) -> void:
	play()