extends Node2D

@export var wheel1: EncoderWheel
@export var wheel2: EncoderWheel
@export var wheel3: EncoderWheel
@export var wheel4: EncoderWheel
@export var padlock_closed: TextureRect
@export var padlock_open: TextureRect

var _code: Array[int] = [1, 7, 5, 8]
var was_entered: bool = false

signal code_was_entered()

func _ready():
	wheel1.number_changed.connect(_on_encoder_wheel_number_changed)
	wheel2.number_changed.connect(_on_encoder_wheel_number_changed)
	wheel3.number_changed.connect(_on_encoder_wheel_number_changed)
	wheel4.number_changed.connect(_on_encoder_wheel_number_changed)

func _on_encoder_wheel_number_changed(_number: int):
	if wheel1._current_number == _code[3] and wheel2._current_number == _code[2] and wheel3._current_number == _code[1] and wheel4._current_number == _code[0]:
			code_entered()

func code_entered():
	if was_entered:
		return
	wheel1.is_locked = true
	wheel2.is_locked = true
	wheel3.is_locked = true
	wheel4.is_locked = true
	was_entered = true
	padlock_closed.hide()
	padlock_open.show()
	# play sound

	# emit signal
	code_was_entered.emit()