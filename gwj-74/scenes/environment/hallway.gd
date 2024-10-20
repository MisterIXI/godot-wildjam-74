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
var toilette_door_open : bool = false
var _tween_toilette_inside : Tween = null
var _tween_toilette_outside : Tween = null
#todo turn of lights

func _ready() -> void:
	# Hallway Inside and Outside
	area_inside.body_entered.connect(_on_area_inside_body_entered)
	area_inside.body_exited.connect(_on_area_inside_body_exited)
	CustomTweener.reset_visibility(hallway_outside, hallway_inside)
	CustomTweener.switch_lights(lights_outside, lights_inside)
	for body in area_inside.get_overlapping_bodies():
		_on_area_inside_body_entered(body)
	set_door(true)

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
	set_toilette_door(true)

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
	CustomTweener.switch_lights(lights_inside, lights_outside)
func set_door(open : bool) -> void:
	entrance_door_collider.disabled = open
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
	toilette_door_collider.disabled = open
	toilette_door_open = open