extends StaticBody2D



#func _ready() -> void:
	#for child in get_children():
		#if child is Interactable:
			#child.interacted.connect(on_interacted)
			#break
	#
#func on_interacted():
	#print(GameState.test_checked)
