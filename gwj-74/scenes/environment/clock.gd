extends Node2D
class_name Clock

@export var minute_hand : Sprite2D = null
@export var hour_hand : Sprite2D = null
var hour: int = 0
var minute: float = 0

func set_time(new_hour: int, new_minute: int) -> void:
	self.hour = new_hour
	self.minute = new_minute
	update_clock()

func advance_times():
	if minute >= 60:
		minute -= 60
		hour += 1
	if hour >= 12:
		hour -= 12

func update_clock() -> void:
	advance_times()
	var minute_angle = minute * 6
	var hour_angle = (hour % 12) * 30 + minute / 2.0
	minute_hand.rotation_degrees = minute_angle
	hour_hand.rotation_degrees = hour_angle

func _physics_process(_delta):
	# minute += _delta * 6
	update_clock()

func get_time() -> String:
	var hour_str = str(hour)
	var minute_str = str(minute)
	if hour < 10:
		hour_str = "0" + hour_str
	if minute < 10:
		minute_str = "0" + minute_str
	return hour_str + ":" + minute_str