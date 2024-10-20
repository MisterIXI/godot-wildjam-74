extends CharacterBody2D
class_name Player

@export var speed = 200.0
@export var acceleration = 0.2
@export var friction = 0.2
@export_range(1,10) var idle_offset = 5.0

var direction: Vector2
var idle_timer = 0.0
var start_speed = 0.0

var start_position: Vector2 = Vector2.ZERO

var zippo_1: AudioStream = preload("res://assets/sounds/zippo_1.wav")
var zippo_2: AudioStream = preload("res://assets/sounds/zippo_2.wav")
var zippo_3: AudioStream = preload("res://assets/sounds/zippo_3.wav")

var random_cig: AudioStreamRandomizer = preload("res://resources/misc/random_cig.tres")

@onready var interaction_ray_cast: RayCast2D = $InteractionRayCast
@onready var interact_bubble: Node2D = %InteractBubble
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var step_player: AudioStreamPlayer = %StepPlayer
@onready var idle_player: AudioStreamPlayer = $IdlePlayer


var is_beeing_controlled = false
var controlled_target: Vector2 = Vector2.ZERO


func _ready() -> void:
	start_position = global_position
	animated_sprite.animation_finished.connect(_on_animation_finished)

	start_speed = speed


func _unhandled_input(_event: InputEvent) -> void:
	# Handle input
	direction = get_input()
	
	# Handle Interaction collision
	if interaction_ray_cast.is_colliding() and interaction_ray_cast.get_collider().is_in_group("Interactable"):
		interact_bubble.bubble_appear()
		if Input.is_action_just_pressed("Interact"):
			interaction_ray_cast.get_collider().interact()
	else:
		interact_bubble.bubble_disappear()


func _physics_process(_delta: float) -> void:
	if DialogueManager.is_in_dialogue:
		direction = Vector2.ZERO


	if is_beeing_controlled:
		direction = controlled_target - global_position
		if direction.length() < 10:
			is_beeing_controlled = false
			direction = Vector2.ZERO
			velocity = Vector2.ZERO
			speed = start_speed
		else:
			direction = direction.normalized()


	# Handle character direction
	animated_sprite.speed_scale = speed / 200
	if abs(direction.x) > abs(direction.y):
		if direction.x < 0:
			animated_sprite.play("sideward-walk")
			animated_sprite.flip_h = true
			interaction_ray_cast.rotation = 0.5 * PI
		elif direction.x > 0:
			animated_sprite.play("sideward-walk")
			animated_sprite.flip_h = false
			interaction_ray_cast.rotation = 1.5 * PI
	else:
		if direction.y > 0:
			animated_sprite.play("forward-walk")
			animated_sprite.flip_h = false
			interaction_ray_cast.rotation = 0
		elif direction.y < 0:
			animated_sprite.play("backward-walk")
			animated_sprite.flip_h = false
			interaction_ray_cast.rotation = PI


	# Handle character movement
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
		idle_timer = 0.0
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
		if interact_bubble.visible == false and not DialogueManager.is_in_dialogue:
			idle_timer += _delta
		if idle_timer > idle_offset:
			if animated_sprite.animation != "start-idle" and animated_sprite.animation != "idle":
				animated_sprite.play("start-idle")
				animated_sprite.flip_h = false
		else:
			animated_sprite.stop()
			animated_sprite.frame = 0
	move_and_slide()


func _on_animation_finished() -> void:
	if animated_sprite.animation == "start-idle":
		animated_sprite.play("idle")


func get_input():
	var horizontal = Input.get_axis("left", "right")
	var vertical = Input.get_axis("up", "down")
	return Vector2(horizontal, vertical)


# Handle Animation SFX
func _on_animated_sprite_2d_frame_changed() -> void:
	# Why is the following line necessary????
	if animated_sprite != null:
		
		# Handle Walk Animation SFX
		if animated_sprite.animation == "forward-walk" or animated_sprite.animation == "backward-walk" or animated_sprite.animation == "sideward-walk":
			match animated_sprite.frame:
				0, 6, 12, 18:
					step_player.play()
		
		# Handle Zippo SFX
		elif animated_sprite.animation == "start-idle":
			if animated_sprite.frame == 4:
				idle_player.stream = zippo_1
				idle_player.play()
			elif animated_sprite.frame == 8:
				idle_player.stream = zippo_2
				idle_player.play()
			elif animated_sprite.frame == 13:
				idle_player.stream = zippo_3
				idle_player.play()
				
		# Handle Smoking SFX
		elif animated_sprite.animation == "idle":
			match animated_sprite.frame:
				0:
					idle_player.pitch_scale = randf_range(0.95, 1.1)
					idle_player.stream = random_cig
					idle_player.play()


func move_to(target_position: Vector2, speed_overrite : float = speed) -> void:
	is_beeing_controlled = true
	controlled_target = target_position
	speed = speed_overrite


func wait_for_player() -> void:
	while is_beeing_controlled:
		await get_tree().create_timer(0.1).timeout


func start_smoking() -> void:
	animated_sprite.play("start-idle")
	animated_sprite.flip_h = false
	idle_timer = idle_offset + 1


func turn(dir: Vector2) -> void:
	if dir.x < 0:
		animated_sprite.flip_h = true
		animated_sprite.play("sideward-walk")
		animated_sprite.stop()
		animated_sprite.frame = 0
	elif dir.x > 0:
		animated_sprite.flip_h = false
		animated_sprite.play("sideward-walk")
		animated_sprite.stop()
		animated_sprite.frame = 0
	elif dir.y > 0:
		animated_sprite.flip_h = false
		animated_sprite.play("forward-walk")
		animated_sprite.stop()
		animated_sprite.frame = 0
	elif dir.y < 0:
		animated_sprite.flip_h = false
		animated_sprite.play("backward-walk")
		animated_sprite.stop()
		animated_sprite.frame = 0


func teleport_to(target_pos: Vector2):
	pass
	var camera : Camera2D = get_node("Camera2D")
	var dist = global_position - camera.get_screen_center_position()
	camera.position -= dist
	global_position = target_pos
	camera.reset_smoothing()
	camera.position = Vector2.ZERO