extends Node

var test_checked: bool = false
var was_outside: bool = false

signal intro_scary_color_changed
var intro_scary_color: bool = false:
	set(value):
		intro_scary_color = value
		intro_scary_color_changed.emit(value)
		
func set_color(timer: float, to_scary: bool) -> void:
	await get_tree().create_timer(timer).timeout
	intro_scary_color = to_scary
