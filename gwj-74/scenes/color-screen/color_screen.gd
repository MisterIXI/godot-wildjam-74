extends CanvasLayer
class_name ColorScreen

@export var game : Node
@export var happy_color = Color(0.7, 0.5, 0.19, 1)
@export var scary_color = Color(0.11, 0.36, 0.38, 1)
@export_range(0, 10) var color_animation_speed : float = 1
@export var dialogue_resource : DialogueResource
@export_range(0, 10) var animation_speed : float = 1


var _tween: Tween
var _screen_tween: Tween
var background : ColorRect

func _ready() -> void:
	GameState.intro_scary_color_changed.connect(_on_intro_color_changed)

	for child in get_children():
		if child is ColorRect:
			background = child
			break
	background.color = _get_target_color(GameState.intro_scary_color)
	background.modulate.a = 0
	background.visible = false

	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

	if OS.get_name() == "Web":
		background.modulate.a = 1
		background.visible = true
		await get_tree().create_timer(1).timeout
		start_dialog("intro")
	else:
		await get_tree().create_timer(0.5).timeout
		GameManager.activate_train_wakeup()


func _on_intro_color_changed(value: bool) -> void:
	if _tween:
		_tween.kill()
	
	_tween = create_tween()
	_tween.tween_property(background, "color", _get_target_color(value), color_animation_speed)


func _get_target_color(value : bool) -> Color:
	if value:
		return scary_color
	else:
		return happy_color


func start_dialog(dialog_string : String) -> void:
	game.process_mode = Node.PROCESS_MODE_DISABLED
	if !background.visible:
		set_visibility(true)
		await _screen_tween.finished
	background.color = _get_target_color(GameState.intro_scary_color)
	BalloonSetter.set_balloon(true)
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialog_string)


func set_visibility(value : bool) -> void:
	_screen_tween = CustomTweener.set_visibility(value, background, _screen_tween, animation_speed)


func _on_dialogue_ended(resource) -> void:
	if resource == dialogue_resource:
		set_visibility(false)
		game.process_mode = Node.PROCESS_MODE_INHERIT
		BalloonSetter.set_balloon(false)
