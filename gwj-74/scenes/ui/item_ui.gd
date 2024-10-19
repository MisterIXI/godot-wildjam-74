extends CanvasLayer

@export var key_train: TextureRect
@export var key_toilette: TextureRect
@export var ticket: TextureRect

func _ready():
	GameState.ui_flags_changed.connect(_on_ui_flags_changed)

## Called when the GameState signals that the UI flags have changed and toggles the visibility of the items.
func _on_ui_flags_changed():
	if GameState.has_train_key and not GameState.train_key_broken:
		key_train.visible = true
	else:
		key_train.visible = false