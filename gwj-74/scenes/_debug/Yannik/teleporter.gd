extends Node2D

@export var threshold_left: Area2D
@export var threshold_right: Area2D
var DIST: float

func _ready():
	DIST = threshold_right.global_position.x - threshold_left.global_position.x - 348

func on_body_entered_from_direction(body: Node, entered_left_area: bool) -> void:
	if body.is_in_group("player"):
		var camera : Camera2D = body.get_node("Camera2D")
		var dist = body.global_position - camera.get_screen_center_position()
		camera.position -= dist
		if entered_left_area:
			body.global_position.x += DIST
		else:
			body.global_position.x -= DIST
		camera.reset_smoothing()
		camera.position = Vector2.ZERO