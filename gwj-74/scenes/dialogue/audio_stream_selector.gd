extends AudioStreamPlayer
class_name AudioStreamSelector

var _parent : DialogueResponsesMenu = null


func _ready() -> void:
	_parent = get_parent()
	print("AudioStreamSelector: Ready")
	_parent.response_selected.connect(_on_response_selected)
	print(_parent, _parent.response_selected)


func _on_response_selected(_response) -> void:
	play()
	print("AudioStreamSelector: Playing audio stream")