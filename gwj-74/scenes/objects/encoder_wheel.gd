extends Panel
class_name EncoderWheel

@export var label1 : Label
@export var label2 : Label
@export var label3 : Label

signal number_changed(number:int)

@export var _current_number : int = 0


var is_locked: bool = false

func _ready():
	_current_number = 0
	update_labels()
	
func on_click() -> void:
	# print("Padlock clicked")
	increment()

func increment():
	set_number(_current_number + 1)

func decrement():
	set_number(_current_number - 1)
	
func set_number(number : int):
	_current_number = number % 10
	update_labels()
	number_changed.emit(_current_number)

func update_labels():
	var num1 = (_current_number-1) % 10
	var num2 = _current_number
	var num3 = (_current_number+1) % 10
	if num1 < 0:
		num1 = 9
	label1.text = str(num1)
	label2.text = str(num2)
	label3.text = str(num3)

func _on_gui_input(event:InputEvent):
	if is_locked:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			on_click()
