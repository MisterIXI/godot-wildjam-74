extends Node2D


func _process(delta: float) -> void:
	if GameState.act_2:
		queue_free()
		
	if GameState.ghost_turn:
		$Ghost.frame = 2
		$Ghost.flip_h = true
