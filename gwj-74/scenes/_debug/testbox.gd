extends StaticBody2D



func _ready() -> void:
	for child in get_children():
		if child is Interactable:
			child.interacted.connect(on_interacted)
			break
	
func on_interacted():
	Dialogic.start('timeline')
	get_viewport().set_input_as_handled()
	print(GameState.test_checked)
