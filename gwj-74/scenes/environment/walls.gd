extends Node2D
class_name Walls

@export var wall_left : StaticBody2D = null
@export var wall_right : StaticBody2D = null

var wall_left_active : bool = true
var wall_right_active : bool = true

func _ready() -> void:
	set_wall_left(false)
	set_wall_right(false)


func set_wall_left(active : bool) -> void:
	wall_left.visible = active
	for item in wall_left.get_children():
		if item is CollisionShape2D:
			item.disabled = not active
	wall_left_active = active


func set_wall_right(active : bool) -> void:
	wall_right.visible = active
	for item in wall_right.get_children():
		if item is CollisionShape2D:
			item.disabled = not active
	wall_right_active = active
