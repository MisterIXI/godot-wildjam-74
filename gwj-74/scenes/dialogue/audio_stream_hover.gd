extends AudioStreamPlayer
class_name AudioStreamHover

var _parent : Button = null


func _ready() -> void:
	_parent = get_parent()
	_parent.gui_input.connect(_on_gui_input)
	_parent.mouse_entered.connect(_on_mouse_entered)


func _on_gui_input(event) -> void:
	if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down") or event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right"):
		play()


func _on_mouse_entered() -> void:
	play()