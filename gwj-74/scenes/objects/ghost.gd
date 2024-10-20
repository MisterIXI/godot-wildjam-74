extends Node2D

func _process(delta: float) -> void:
	if GameState.has_train_key:
		queue_free()
