extends CanvasLayer

@export var environment : xXxEnvironmentxXx = null
@export var player : Player = null
@export var color_screen : ColorScreen = null

@export var player_text : TextEdit = null
@export var player_button : Button = null
@export var clock_text : TextEdit = null
@export var clock_button : Button = null
@export var color_text : TextEdit = null
@export var color_button : Button = null
@export var walls_left_check : CheckButton = null
@export var walls_right_check : CheckButton = null
@export var train_front_check : CheckButton = null
@export var train_back_check : CheckButton = null
@export var train_inside_check : CheckButton = null
@export var counter_door_check : CheckButton = null
@export var counter_man_check : CheckButton = null


func _ready() -> void:
	await get_tree().create_timer(0.1).timeout

	player_button.pressed.connect(_on_player_button_pressed)
	clock_button.pressed.connect(_on_clock_button_pressed)
	color_button.pressed.connect(_on_color_button_pressed)

	walls_left_check.toggled.connect(_on_walls_left_check_pressed)
	if environment.walls.wall_left_active:
		walls_left_check.button_pressed = true
	walls_right_check.toggled.connect(_on_walls_right_check_pressed)
	if environment.walls.wall_right_active:
		walls_right_check.button_pressed = true
	
	train_front_check.toggled.connect(_on_train_front_check_pressed)
	if environment.train.door_front_open:
		train_front_check.button_pressed = true
	train_back_check.toggled.connect(_on_train_back_check_pressed)
	if environment.train.door_back_open:
		train_back_check.button_pressed = true
	train_inside_check.toggled.connect(_on_train_inside_check_pressed)
	if environment.train.door_inside_open:
		train_inside_check.button_pressed = true
	
	counter_door_check.toggled.connect(_on_counter_door_check_pressed)
	if environment.counter.door_open:
		counter_door_check.button_pressed = true
	counter_man_check.toggled.connect(_on_counter_man_check_pressed)
	if environment.counter.man_active:
		counter_man_check.button_pressed = true


func _on_player_button_pressed() -> void:
	if player_text.text == "":
		clock_text.release_focus()
		return
	player.speed = player_text.text.to_float()
	player_text.text = ""
	player_text.release_focus()


func _on_clock_button_pressed() -> void:
	if clock_text.text.find(":") == -1:
		clock_text.text = ""
		clock_text.release_focus()
		return
	var hour = clock_text.text.split(":")[0].to_int()
	var minute = clock_text.text.split(":")[1].to_int()
	environment.clock.set_time(hour, minute)
	clock_text.text = ""
	clock_text.release_focus()


func _on_color_button_pressed() -> void:
	if color_text.text == "":
		color_text.release_focus()
		return
	if color_text.text in color_screen.dialogue_resource.titles:
		color_screen.start_dialog(color_text.text)
		color_text.text = ""
	color_text.release_focus()


func _on_walls_left_check_pressed(value : bool) -> void:
	environment.walls.set_wall_left(value)
func _on_walls_right_check_pressed(value : bool) -> void:
	environment.walls.set_wall_right(value)


func _on_train_front_check_pressed(value : bool) -> void:
	environment.train.set_door(value, 0)
func _on_train_back_check_pressed(value : bool) -> void:
	environment.train.set_door(value, 1)
func _on_train_inside_check_pressed(value : bool) -> void:
	environment.train.set_door_inside(value)


func _on_counter_door_check_pressed(value : bool) -> void:
	environment.counter.set_door(value)
func _on_counter_man_check_pressed(value : bool) -> void:
	environment.counter.show_man(value)
