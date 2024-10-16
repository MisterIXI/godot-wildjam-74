extends Node2D

var jiggle_speed: float = 0.5
var bubble_up: bool = false

@onready var jiggle_pivot: Node2D = %JigglePivot

func _ready() -> void:
	visible = false
	scale = Vector2(0.1, 0.1)
	rotation_degrees = 60
	
func _physics_process(delta: float) -> void:
	jiggle()

func bubble_appear() -> void:
	visible = true
	bubble_up = true
	var tween: Tween = create_tween()
	tween.set_parallel()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.25)
	tween.tween_property(self, "rotation_degrees", 0, 0.25)
	
func bubble_disappear() -> void:
	if bubble_up:
		bubble_up = false
		var tween: Tween = create_tween()
		tween.set_parallel()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "scale", Vector2(0.1, 0.1), 0.25)
		tween.tween_property(self, "rotation_degrees", 60, 0.25)
		await tween.finished
		visible = false
	
func jiggle() -> void:
	var tween: Tween
	if tween == null:
		tween = create_tween()
		tween.set_parallel()
		tween.tween_property(jiggle_pivot, "position", Vector2(randf_range(-10, 10), randf_range(-10, 10)), 1 / jiggle_speed)
		tween.tween_property(jiggle_pivot, "rotation_degrees", randi_range(-10, 10), 1 / jiggle_speed)
