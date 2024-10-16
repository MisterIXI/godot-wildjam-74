extends Node2D
class_name Train

@export var train_area : Area2D = null
@export var train_outside : Node2D = null
@export var train_inside : Node2D = null
@export var lights_outside : Node2D = null
@export var lights_inside : Node2D = null
@export var train_door_front : Node2D = null
@export var train_door_front_static_body : StaticBody2D = null
@export var train_door_back : Node2D = null
@export var train_door_back_static_body : StaticBody2D = null
@export var train_door_inside_collider : CollisionShape2D = null
@export var train_door_inside : CanvasItem = null
@export_range(0, 2) var animation_duration : float = 0.3
@export_range(0, 2) var door_animation_duration : float = 0.3


var door_front_open : bool = true
var door_back_open : bool = true
var door_inside_open : bool = true


var _tween_outside : Tween = null
var _tween_inside : Tween = null
var _tween_door_front : Tween = null
var _tween_door_back : Tween = null
var _tween_door_inside : Tween = null


func _ready():
	train_area.body_entered.connect(_on_body_entered)
	train_area.body_exited.connect(_on_body_exited)

	CustomTweener.reset_visibility(train_outside, train_inside)
	for body in train_area.get_overlapping_bodies():
		_on_body_entered(body)
	
	set_door(train_door_front.visible, 0)
	set_door(train_door_back.visible, 1)
	set_door_inside(train_door_inside_collider.disabled)


func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	CustomTweener.tween_visibility(train_inside, _tween_inside, train_outside, _tween_outside, animation_duration)
	lights_outside.visible = false
	lights_inside.visible = true


func _on_body_exited(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	CustomTweener.tween_visibility(train_outside, _tween_outside, train_inside, _tween_inside, animation_duration)
	lights_inside.visible = false
	lights_outside.visible = true


func set_door(open : bool, wagon_id : int) -> void:
	if wagon_id == 0:
		for child in train_door_front_static_body.get_children():
			child.disabled = open
		CustomTweener.set_visibility(open, train_door_front, _tween_door_front, door_animation_duration)
		door_front_open = open
	elif wagon_id == 1:
		for child in train_door_back_static_body.get_children():
			child.disabled = open
		CustomTweener.set_visibility(open, train_door_back, _tween_door_back, door_animation_duration)
		door_back_open = open
	else:
		print("Invalid wagon id: ", wagon_id)
		return


func set_door_inside(open : bool) -> void:
	train_door_inside_collider.disabled = open
	CustomTweener.set_visibility(open, train_door_inside, _tween_door_inside, door_animation_duration)
	door_inside_open = open
