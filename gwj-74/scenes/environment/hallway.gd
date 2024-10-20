extends Node2D
class_name Hallway


@export_range(0, 2) var animation_duration : float = 0.3

@export_group("Hallway Inside and Outside")
@export var area_inside : Area2D = null
@export var hallway_inside : Node2D = null
@export var hallway_outside : Node2D = null
@export var entrance_door : Node2D = null
@export var entrance_door_collider : CollisionShape2D = null
@export var lights_inside : Array[Node2D] = []
@export var lights_outside : Array[Node2D] = []
var door_open : bool = false
var _tween_inside : Tween = null
var _tween_outside : Tween = null

@export_group("Janitor")
@export var janitor_area : Area2D = null
@export var janitor_inside : Node2D = null
@export var janitor_lights_inside : Array[Node2D] = []
@export var janitor_lights_outside : Array[Node2D] = []
var _tween_janitor_inside : Tween = null
var _tween_janitor_outside : Tween = null

@export_group("Hallway Base and Extension")
@export var hallway_base : Node2D = null
@export var hallway_extension : Node2D = null
@export var hallway_extension_lights : Array[Node2D] = []
@export var hallway_extension_collider : CollisionShape2D = null

@export_group("Toilette")
@export var toilette_area : Area2D = null
@export var toilette_inside : Node2D = null
@export var toilette_lights_inside : Array[Node2D] = []
@export var toilette_lights_outside : Array[Node2D] = []
@export var toilette_door_collider : CollisionShape2D = null
@export var toilette_door : Array[Node2D] = []
@export var stall_door : Node2D = null
@export var stall_door_collider : CollisionShape2D = null
@export var stall_walls : Array[CanvasItem] = []
@export var stall_area : Area2D = null
var toilette_door_open : bool = false
var stall_door_open : bool = false
var _tween_toilette_door : Tween = null
var _tween_stall : Tween = null
var _tween_toilette_inside : Tween = null
var _tween_toilette_outside : Tween = null

@export_group("Animation")
@export var ghost : AnimatedSprite2D = null
@export var exit_door : Node2D = null
@export var exit_door_collider : CollisionShape2D = null
@export var hallway_copy : Node2D = null
@export var toilette_interactionbox : StaticBody2D = null
@export var toilette_ghost : AnimatedSprite2D = null
var _tween_ghost : Tween = null
var exit_door_open : bool = false

func _ready() -> void:
	# Hallway Inside and Outside
	area_inside.body_entered.connect(_on_area_inside_body_entered)
	area_inside.body_exited.connect(_on_area_inside_body_exited)
	CustomTweener.reset_visibility(hallway_outside, hallway_inside)
	CustomTweener.switch_lights(lights_outside, lights_inside)
	for body in area_inside.get_overlapping_bodies():
		_on_area_inside_body_entered(body)
	set_door(false)

	# Janitor
	janitor_area.body_entered.connect(_on_janitor_area_body_entered)
	janitor_area.body_exited.connect(_on_janitor_area_body_exited)
	janitor_inside.visible = false
	janitor_inside.modulate.a = 0
	CustomTweener.switch_lights(janitor_lights_outside, janitor_lights_inside)
	for body in janitor_area.get_overlapping_bodies():
		_on_janitor_area_body_entered(body)
	
	# Hallway Base and Extension
	set_hallway_extension(false)
	
	# Toilette
	toilette_area.body_entered.connect(_on_toilette_area_body_entered)
	toilette_area.body_exited.connect(_on_toilette_area_body_exited)
	toilette_inside.visible = false
	toilette_inside.modulate.a = 0
	CustomTweener.switch_lights(toilette_lights_outside, toilette_lights_inside)
	for body in toilette_area.get_overlapping_bodies():
		_on_toilette_area_body_entered(body)
	set_toilette_door(false)
	set_stall_door(false)
	stall_area.body_entered.connect(_on_stall_area_body_entered)
	stall_area.body_exited.connect(_on_stall_area_body_exited)

	# Animation
	ghost.visible = false
	ghost.modulate.a = 0

# Hallway Inside and Outside
func _on_area_inside_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	var tween_array = CustomTweener.tween_visibility(hallway_inside, _tween_inside, hallway_outside, _tween_outside, animation_duration)
	_tween_inside = tween_array[0]
	_tween_outside = tween_array[1]
	CustomTweener.switch_lights(lights_inside, lights_outside)
func _on_area_inside_body_exited(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	var tween_array = CustomTweener.tween_visibility(hallway_outside, _tween_outside, hallway_inside, _tween_inside, animation_duration)
	_tween_outside = tween_array[0]
	_tween_inside = tween_array[1]
	CustomTweener.switch_lights(lights_outside, lights_inside)
func set_door(open : bool) -> void:
	entrance_door_collider.disabled = open
	entrance_door.visible = open
	door_open = open

# Janitor
func _on_janitor_area_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	var tween_array = CustomTweener.tween_visibility(janitor_inside, _tween_janitor_inside, hallway_outside, _tween_janitor_outside, animation_duration)
	_tween_janitor_inside = tween_array[0]
	_tween_janitor_outside = tween_array[1]
	CustomTweener.switch_lights(janitor_lights_inside, janitor_lights_outside)
func _on_janitor_area_body_exited(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	var tween_array = CustomTweener.tween_visibility(hallway_outside, _tween_janitor_outside, janitor_inside, _tween_janitor_inside, animation_duration)
	_tween_janitor_outside = tween_array[0]
	_tween_janitor_inside = tween_array[1]
	CustomTweener.switch_lights(janitor_lights_outside, janitor_lights_inside)


# Hallway Base and Extension
func set_hallway_extension(extend : bool) -> void:
	hallway_extension.visible = extend
	for light in hallway_extension_lights:
		light.visible = extend
	hallway_extension_collider.disabled = extend


# Toilette
func _on_toilette_area_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	var tween_array = CustomTweener.tween_visibility(toilette_inside, _tween_toilette_inside, hallway_outside, _tween_toilette_outside, animation_duration)
	_tween_toilette_inside = tween_array[0]
	_tween_toilette_outside = tween_array[1]
	CustomTweener.switch_lights(toilette_lights_inside, toilette_lights_outside)
func _on_toilette_area_body_exited(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	var tween_array = CustomTweener.tween_visibility(hallway_outside, _tween_toilette_outside, toilette_inside, _tween_toilette_inside, animation_duration)
	_tween_toilette_outside = tween_array[0]
	_tween_toilette_inside = tween_array[1]
	CustomTweener.switch_lights(toilette_lights_outside, toilette_lights_inside)
func set_toilette_door(open : bool) -> void:
	if toilette_door != null:
		for door in toilette_door:
			_tween_toilette_door = CustomTweener.set_visibility(open, door, _tween_toilette_door, animation_duration)
	toilette_door_collider.disabled = open
	toilette_door_open = open


func set_stall_door(open : bool) -> void:
	_tween_stall = CustomTweener.set_visibility(not open, stall_door, _tween_stall, animation_duration)
	stall_door_collider.disabled = open
	stall_door_open = open
func _on_stall_area_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	for wall in stall_walls:
		wall.z_as_relative = false
		wall.z_index = 500
	stall_door.z_as_relative = false
	stall_door.z_index = 500
func _on_stall_area_body_exited(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	for wall in stall_walls:
		wall.z_as_relative = true
		wall.z_index = 0
	stall_door.z_as_relative = true
	stall_door.z_index = 0


# animation
func ghost_appear() -> void:
	ghost.visible = true
	ghost.play("front")
	_tween_ghost = CustomTweener.set_visibility(true, ghost, _tween_ghost, 2)
	await _tween_ghost.finished


func ghost_disappear() -> void:
	_tween_ghost = CustomTweener.set_visibility(false, ghost, _tween_ghost, 2)
	await _tween_ghost.finished


func ghost_approach_player() -> void:
	ghost.play("side")
	if _tween_ghost:
		_tween_ghost.kill()
	_tween_ghost = create_tween()
	_tween_ghost.tween_property(ghost, "position:x", 1971, 3)
	await _tween_ghost.finished
	await get_tree().create_timer(1).timeout


func switch_hall(to_right_hall : bool) -> void:
	var player = GameManager.main.player
	var camera : Camera2D = player.get_node("Camera2D")
	var dist = player.global_position - camera.get_screen_center_position()
	camera.position -= dist

	if to_right_hall:
		player.global_position += hallway_copy.global_position - hallway_base.global_position
	else:
		player.global_position += hallway_base.global_position - hallway_copy.global_position

	camera.reset_smoothing()
	camera.position = Vector2.ZERO

	set_door(not to_right_hall)
	exit_door_collider.disabled = to_right_hall
	exit_door.visible = to_right_hall
	exit_door_open = to_right_hall


func kill_toilette_interactionbox() -> void:
	toilette_interactionbox.queue_free()


func toilette_ghost_animation() -> void:
	toilette_ghost.visible = true
	var target_positions = []
	for child in toilette_ghost.get_children():
		target_positions.append(child.global_position)
	for pos in target_positions:
		_move_toilette_ghost(pos)
		await _tween_ghost.finished
		for i in range(3):
			_toilette_ghost_look_around(i)
			await get_tree().create_timer(1).timeout
	toilette_ghost.visible = false



func _move_toilette_ghost(pos : Vector2) -> void:
	if _tween_ghost:
		_tween_ghost.kill()
	_tween_ghost = create_tween()
	_tween_ghost.tween_property(toilette_ghost, "global_position", pos, 3)
	
	var direction = toilette_ghost.global_position - pos
	if direction.x > 0:
		toilette_ghost.flip_h = true
		toilette_ghost.play("side")
	elif direction.x < 0:
		toilette_ghost.flip_h = false
		toilette_ghost.play("side")
	elif direction.y > 0:
		toilette_ghost.play("back")
		toilette_ghost.flip_h = false
	else:
		toilette_ghost.play("front")
		toilette_ghost.flip_h = false
	


func _toilette_ghost_look_around(time) -> void:
	match time:
			1:
				toilette_ghost.flip_h = false
				toilette_ghost.play("front")
			0:
				toilette_ghost.flip_h = true
				toilette_ghost.play("side")
			3:
				toilette_ghost.flip_h = false
				toilette_ghost.play("back")
			2:
				toilette_ghost.flip_h = false
				toilette_ghost.play("side")
			_:
				pass
