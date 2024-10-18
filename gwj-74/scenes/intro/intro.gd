extends CanvasLayer
class_name Intro


@export var happy_color = Color(0.7, 0.5, 0.19, 1)
@export var scary_color = Color(0.11, 0.36, 0.38, 1)
@export_range(0, 10) var animation_speed = 1

var _tween: Tween
var background : ColorRect

func _ready() -> void:
	GameState.intro_scary_color_changed.connect(_on_intro_color_changed)

	for child in get_children():
		if child is ColorRect:
			background = child
			break
	background.color = _get_target_color(GameState.intro_scary_color)


func _on_intro_color_changed(value: bool) -> void:
	print("Intro color changed to", value)
	if _tween:
		_tween.kill()
	
	_tween = create_tween()
	_tween.tween_property(background, "color", _get_target_color(value), animation_speed)


func _get_target_color(value : bool) -> Color:
	if value:
		return scary_color
	else:
		return happy_color
