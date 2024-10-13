extends CharacterBody2D


@export var speed = 200.0
@export var acceleration = 0.2
@export var friction = 0.2

var sprite_front = preload("res://assets/images/temp/character-front.png")
var sprite_back = preload("res://assets/images/temp/character-back.png")
var sprite_left = preload("res://assets/images/temp/character-left.png")

var direction: Vector2

@onready var character_sprite: Sprite2D = %CharacterSprite
@onready var interaction_ray_cast: RayCast2D = $InteractionRayCast


func _unhandled_input(event: InputEvent) -> void:
	
	# Handle input
	direction = get_input()
	
	# Handle Interaction collision
	if interaction_ray_cast.is_colliding() and Input.is_action_just_pressed("Interact"):
		if interaction_ray_cast.get_collider().is_in_group("Interactable"):
			interaction_ray_cast.get_collider().interact()


func _physics_process(delta: float) -> void:
	
	# Handle character direction
	if direction.y < 0 and direction.x == 0:
		character_sprite.texture = sprite_back
		interaction_ray_cast.rotation = PI
	if direction.y > 0 and direction.x == 0:
		character_sprite.texture = sprite_front
		interaction_ray_cast.rotation = 0
	if direction.x < 0 and direction.y == 0:
		character_sprite.texture = sprite_left
		interaction_ray_cast.rotation = 0.5 * PI
		character_sprite.flip_h = false
	if direction.x > 0 and direction.y == 0:
		character_sprite.texture = sprite_left
		character_sprite.flip_h = true
		interaction_ray_cast.rotation = 1.5 * PI
	
	# Handle character movement
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	move_and_slide()


func get_input():
	var horizontal = Input.get_axis("left", "right")
	var vertical = Input.get_axis("up", "down")
	return Vector2(horizontal, vertical)
	
