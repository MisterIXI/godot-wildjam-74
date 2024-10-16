extends Node2D
class_name Counter

@export var counter_area : Area2D = null
@export var counter_man : Node2D = null
@export var counter_outside : Node2D = null
@export var counter_inside : Node2D = null
@export var lights_outside : Array[Node2D] = []
@export var lights_inside : Array[Node2D] = []
@export var counter_door_collider : CollisionShape2D = null
@export_range(0, 2) var animation_duration : float = 0.3


@export var man_flicker_pause_range : Vector2 = Vector2(3, 5)
@export var man_flicker_count_range : Vector2i = Vector2i(1, 3)
@export_range(0, 2) var man_flicker_duration : float = 0.05


var door_open : bool = true
var man_active : bool = true


var _tween_inside : Tween = null
var _tween_outside : Tween = null
var _tween_man : Tween = null


func _ready():
	counter_area.body_entered.connect(_on_body_entered)
	counter_area.body_exited.connect(_on_body_exited)

	CustomTweener.reset_visibility(counter_outside, counter_inside)
	for body in counter_area.get_overlapping_bodies():
		_on_body_entered(body)
	
	set_door(counter_door_collider.disabled)
	show_man(false)


func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	CustomTweener.tween_visibility(counter_inside, _tween_inside, counter_outside, _tween_outside, animation_duration)
	if !lights_outside.is_empty():
		for light in lights_outside:
			light.visible = false
	if !lights_inside.is_empty():
		for light in lights_inside:
			light.visible = true


func _on_body_exited(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	CustomTweener.tween_visibility(counter_outside, _tween_outside, counter_inside, _tween_inside, animation_duration)
	if !lights_outside.is_empty():
		for light in lights_outside:
			light.visible = true
	if !lights_inside.is_empty():
		for light in lights_inside:
			light.visible = false


func set_door(open : bool) -> void:
	counter_door_collider.disabled = open
	door_open = open


func show_man(active : bool) -> void:
	counter_man.visible = active
	man_active = active

	if active:
		_man_flicker()
	elif _tween_man:
		_tween_man.kill()


func _man_flicker() -> void:
	var duration = randf_range(man_flicker_pause_range.x, man_flicker_pause_range.y)
	await get_tree().create_timer(duration).timeout

	if not man_active:
		return

	if _tween_man:
		_tween_man.kill()
	_tween_man = get_tree().create_tween()

	var _count = randi_range(man_flicker_count_range.x, man_flicker_count_range.y)
	for i in range(_count):
		_tween_man.tween_property(counter_man, "modulate:a", 0.5, man_flicker_duration)
		_tween_man.tween_property(counter_man, "modulate:a", 1, man_flicker_duration)
	_tween_man.tween_callback(_man_flicker)
