extends Node

var test_checked: bool = false
var was_outside: bool = false

signal intro_scary_color_changed
var intro_scary_color: bool = false:
	set(value):
		intro_scary_color = value
		intro_scary_color_changed.emit(value)
