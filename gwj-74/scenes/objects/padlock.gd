extends Node2D
class_name Padlock

@export var wheel1: EncoderWheel
@export var wheel2: EncoderWheel
@export var wheel3: EncoderWheel
@export var wheel4: EncoderWheel
@export var padlock_closed: TextureRect
@export var padlock_open: TextureRect
@export var canvas: CanvasLayer

var was_entered: bool = false

signal code_was_entered()
signal closed_lock()

func _ready():
	wheel1.number_changed.connect(_on_encoder_wheel_number_changed)
	wheel2.number_changed.connect(_on_encoder_wheel_number_changed)
	wheel3.number_changed.connect(_on_encoder_wheel_number_changed)
	wheel4.number_changed.connect(_on_encoder_wheel_number_changed)
	canvas.set_deferred("visible", false)
	canvas.visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed():
	if canvas.visible:
		var num1 = int(GameState.current_padlock_code[3])
		var num2 = int(GameState.current_padlock_code[2])
		var num3 = int(GameState.current_padlock_code[1])
		var num4 = int(GameState.current_padlock_code[0])
		wheel1.set_number(num1)
		wheel2.set_number(num2)
		wheel3.set_number(num3)
		wheel4.set_number(num4)

func set_visbilility(new_state: bool):
	canvas.set_deferred("visible", new_state)

func _on_encoder_wheel_number_changed(_number: int):
	GameState.current_padlock_code = "" + str(wheel4._current_number) + str(wheel3._current_number) + str(wheel2._current_number) + str(wheel1._current_number)
	if GameState.padlock_code == GameState.current_padlock_code:
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

func dialogue_trigger():
	canvas.set_deferred("visible", true)
	await closed_lock

func on_background_clicked():
	canvas.set_deferred("visible", false)
	closed_lock.emit()

func _on_background_panel_gui_input(event:InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			on_background_clicked()