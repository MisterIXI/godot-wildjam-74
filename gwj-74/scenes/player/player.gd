extends CharacterBody2D
class_name Player

@export var speed = 200.0
@export var acceleration = 0.2
@export var friction = 0.2
@export_range(1,10) var idle_offset = 5.0

var direction: Vector2
var idle_timer = 0.0

var zippo_1: AudioStream = preload("res://assets/sounds/zippo_1.wav")
var zippo_2: AudioStream = preload("res://assets/sounds/zippo_2.wav")
var zippo_3: AudioStream = preload("res://assets/sounds/zippo_3.wav")

var random_cig: AudioStreamRandomizer = preload("res://resources/misc/random_cig.tres")

@onready var interaction_ray_cast: RayCast2D = $InteractionRayCast
@onready var interact_bubble: Node2D = %InteractBubble
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var step_player: AudioStreamPlayer = %StepPlayer
@onready var idle_player: AudioStreamPlayer = $IdlePlayer





func _ready() -> void:
	animated_sprite.animation_finished.connect(_on_animation_finished)


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
	
	# Handle character direction
	if direction.y < 0 and direction.x == 0:
		animated_sprite.play("backward-walk")
		animated_sprite.flip_h = false
		interaction_ray_cast.rotation = PI
	if direction.y > 0 and direction.x == 0:
		animated_sprite.play("forward-walk")
		animated_sprite.flip_h = false
		interaction_ray_cast.rotation = 0
	if direction.x < 0 and direction.y == 0:
		animated_sprite.play("sideward-walk")
		animated_sprite.flip_h = false
		interaction_ray_cast.rotation = 0.5 * PI
	if direction.x > 0 and direction.y == 0:
		animated_sprite.play("sideward-walk")
		animated_sprite.flip_h = true
		interaction_ray_cast.rotation = 1.5 * PI

	# Handle character movement
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
		idle_timer = 0.0
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
		if interact_bubble.visible == false:
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
		if animated_sprite.animation == "forward-walk":
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
