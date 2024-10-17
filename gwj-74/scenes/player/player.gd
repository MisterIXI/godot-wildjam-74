extends CharacterBody2D
class_name Player

@export var speed = 200.0
@export var acceleration = 0.2
@export var friction = 0.2
@export_range(1,10) var idle_offset = 5.0

var direction: Vector2
var idle_timer = 0.0

@onready var interaction_ray_cast: RayCast2D = $InteractionRayCast
@onready var interact_bubble: Node2D = %InteractBubble
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


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
		idle_timer += _delta
		if idle_timer > idle_offset:
			if animated_sprite.animation != "start-idle" and animated_sprite.animation != "idle":
				animated_sprite.play("start-idle")
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
	
