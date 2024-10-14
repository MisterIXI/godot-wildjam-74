extends Node2D
class_name Teleporter

@export var threshold_left: Area2D
@export var threshold_right: Area2D
var DIST: float

func _ready():
	DIST = threshold_right.global_position.x - threshold_left.global_position.x - 348 * 3
	threshold_left.body_entered.connect(on_body_entered_from_direction.bind(true))
	threshold_right.body_entered.connect(on_body_entered_from_direction.bind(false))

func on_body_entered_from_direction(body: Node, entered_left_area: bool) -> void:
	if body.is_in_group("player"):
		var player = body as CharacterBody2D
		var max_width = 0
		for colshape in player.get_children().filter(func(child: Node): return child is CollisionObject2D):
			# check if circle shape for radius
			if colshape.shape is CircleShape2D:
				var radius = colshape.shape.radius
				if radius > max_width:
					max_width = radius
			else:
				var width = colshape.shape.extents.x
				if width > max_width:
					max_width = width
		var camera : Camera2D = body.get_node("Camera2D")
		var dist = body.global_position - camera.get_screen_center_position()
		camera.position -= dist
		if entered_left_area:
			body.global_position.x += DIST
		else:
			body.global_position.x -= DIST
		camera.reset_smoothing()
		camera.position = Vector2.ZERO