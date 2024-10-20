extends Node
signal ui_flags_changed
var test_checked: bool = false

var wrapped_around: bool = false
var ghost_met: bool = false
var act_2: bool = false

# Environment
var clock_checked: bool = false
var clock_spinning: bool = false
var met_vending_machine: bool = false
var newspaper_read: bool = false
var ghost_turn: bool = false
var current_padlock_code: String = "6813"
var padlock_code : String = "1758"
var safe_open: bool = false

# Items 
var has_train_key: bool = false:
	set(value): 
		has_train_key = value
		ui_flags_changed.emit()
var train_key_broken: bool = false:
	set(value): 
		train_key_broken = value
		ui_flags_changed.emit()
var has_toilette_key: bool = false:
	set(value): 
		has_toilette_key = value
		ui_flags_changed.emit()
var toilette_key_used: bool = false:
	set(value): 
		toilette_key_used = value
		ui_flags_changed.emit()
var has_ticked : bool = false:
	set(value): 
		has_ticked = value
		ui_flags_changed.emit()
# Cutscenes
var is_awake: bool = false
var clerk_appear_happened: bool = false
var was_outside: bool = false

signal intro_scary_color_changed
var intro_scary_color: bool = false:
	set(value):
		intro_scary_color = value
		intro_scary_color_changed.emit(value)
		
func set_color(timer: float, to_scary: bool) -> void:
	await get_tree().create_timer(timer).timeout
	intro_scary_color = to_scary
