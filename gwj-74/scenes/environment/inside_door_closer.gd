extends Area2D

@export var train : Train = null


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	if train.door_inside_open and GameState.train_key_broken:
		train.call_deferred("set_door_inside", false)
