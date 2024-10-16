extends Node
class_name Flicker


@export var offset_range : Vector2 = Vector2(3, 5)
@export var duration_range : Vector2 = Vector2(0.05, 0.1)
@export var count_range : Vector2i = Vector2i(1, 3)
@export var intensity_range : Vector2 = Vector2(0.2, 0.5)

var _parent : PointLight2D
var _start_energy : float
var _tween : Tween


func _ready() -> void:
	_parent = get_parent()
	_start_energy = _parent.energy
	flicker()


func flicker() -> void:
	await get_tree().create_timer(randf_range(offset_range.x, offset_range.y)).timeout
	if _tween:
		_tween.kill()
	
	_tween = get_tree().create_tween()
	var _count = randi_range(count_range.x, count_range.y)
	for i in range(_count):
		_tween.tween_property(_parent, "energy", randf_range(intensity_range.x, intensity_range.y), randf_range(duration_range.x, duration_range.y))
		_tween.tween_property(_parent, "energy", _start_energy, randf_range(duration_range.x, duration_range.y))
	_tween.tween_callback(flicker)
