extends Node

var main : Main

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
