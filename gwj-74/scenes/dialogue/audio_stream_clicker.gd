extends AudioStreamPlayer
class_name AudioStreamClicker


var _parent : DialogueLabel = null


func _ready() -> void:
	_parent = get_parent()
	_parent.spoke.connect(_on_spoke)


func _on_spoke(_some_var, _another_var, _something_else) -> void:
	play()