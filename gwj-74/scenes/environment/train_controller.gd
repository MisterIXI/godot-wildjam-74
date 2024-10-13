extends Node2D
class_name TrainController

@export var area : Area2D = null
@export var inside : Node2D = null
@export var outside : Node2D = null
@export var entrance_front : Node2D = null
@export var entrance_back : Node2D = null
@export_range(0, 2) var animation_duration : float = 0.4

var inside_tween : Tween = null
var outside_tween : Tween = null
var entrance_front_tween : Tween = null
var entrance_back_tween : Tween = null

func _ready():
	if area != null:
		area.body_entered.connect(_on_body_entered)
		area.body_exited.connect(_on_body_exited)
	else:
		print("TrainController: Area2D not found")
	print("TrainController: Ready")


func _on_body_entered(body: Node) -> void:
	print("TrainController: Body entered")
	if body.is_in_group("player"):
		if inside_tween != null:
			inside_tween.kill()
		inside_tween = get_tree().create_tween()

		inside.modulate.a = 0
		inside.visible = true
		inside_tween.tween_property(inside, "modulate:a", 1, animation_duration)

		if outside_tween != null:
			outside_tween.kill()
		outside_tween = get_tree().create_tween()

		outside.modulate.a = 1
		outside.visible = true
		outside_tween.tween_property(outside, "modulate:a", 0, animation_duration)
		outside_tween.tween_callback(outside.hide)


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		if inside_tween != null:
			inside_tween.kill()
		inside_tween = get_tree().create_tween()

		inside.modulate.a = 1
		inside.visible = true
		inside_tween.tween_property(inside, "modulate:a", 0, animation_duration)
		inside_tween.tween_callback(inside.hide)

		if outside_tween != null:
			outside_tween.kill()
		outside_tween = get_tree().create_tween()

		outside.modulate.a = 0
		outside.visible = true
		outside_tween.tween_property(outside, "modulate:a", 1, animation_duration)


func show_entrance(value: bool, wagon : int) -> void:
	var value_int
	if value:
		value_int = 1
	else:
		value_int = 0

	if wagon == 0:
		if entrance_front_tween != null:
			entrance_front_tween.kill()
		entrance_front_tween = get_tree().create_tween()

		entrance_front.modulate.a = 0
		entrance_front.visible = true
		entrance_front_tween.tween_property(entrance_front, "modulate:a", value_int, animation_duration)
		if !value:
			entrance_front_tween.tween_callback(entrance_front.hide)
	else:
		if entrance_back_tween != null:
			entrance_back_tween.kill()
		entrance_back_tween = get_tree().create_tween()

		entrance_back.modulate.a = 0
		entrance_back.visible = true
		entrance_back_tween.tween_property(entrance_back, "modulate:a", value_int, animation_duration)
		if !value:
			entrance_back_tween.tween_callback(entrance_back.hide)
