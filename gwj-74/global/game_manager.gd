extends Node

var main : Main
@export var black_tex: TextureRect

func _ready():
	main = get_parent().get_node("Main")

func clerk_appear():
	main.environment.counter.show_man(true)

func clerk_disappear():
	main.environment.counter.show_man(false)

func unlock_counter_door():
	main.environment.counter.set_door(true)

func lock_counter_door():
	main.environment.counter.set_door(false)

func train_blackout():
	# tween until opacity is 1
	var tween = create_tween()
	tween.tween_property(black_tex, "modulate:a", 1, 1)
	await tween.finished
	# teleport player
	main.player.teleport_to(main.player.start_position)
	main.player.turn(Vector2.DOWN)
	main.environment.hallway.set_door(true)
	# tween until opacity is 0
	tween = create_tween()
	tween.tween_property(black_tex, "modulate:a", 0, 2)
	await tween.finished

func activate_train_wakeup():
	main.environment.train.train_wakeup_actionator.get_child(0).set_deferred("disabled", false)

func remove_toilette_door():
	main.environment.hallway.toilette_door_interactable.queue_free()
	main.environment.hallway.set_toilette_door(true)
