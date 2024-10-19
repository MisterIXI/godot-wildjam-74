@icon("res://components/actionator/actionator.png")
extends Area2D
class_name Actionator
## Activates some action when the player enters the area.

@export_group("General")
## Only use the actionator once. This Node will destroy itself after the first use.
@export var only_use_once : bool = false
## Only activate the actionator if some specific game states are set either true or false. The name of the game state variable.
@export var only_on_game_state_name  : Array[String] = []
## The value the game state variable should be set to.
@export var only_on_game_state_value : Array[bool] = []


@export_group("Start Dialogue")
## The string name of the dialogue
@export var dialogue_string : String = ""
## The dialogue resource to use
@export var dialogue_resource : DialogueResource = null


@export_group("Set Game State")
## Set the game state variable to a specific value. The name of the game state variable.
@export var set_game_state_name : Array[String] = []
## The value to set the game state variable to.
@export var set_game_state_value : Array[bool] = []


func _ready() -> void:
	body_entered.connect(_on_body_entered)

	if only_on_game_state_name.size() > 0 and only_on_game_state_value.size() > 0:
		if only_on_game_state_name.size() != only_on_game_state_value.size():
			print("### ACTIONATOR WARNING #### Only on Game state name and value arrays are not the same size in: " + name)
	
	if set_game_state_name.size() > 0 and set_game_state_value.size() > 0:
		if set_game_state_name.size() != set_game_state_value.size():
			print("### ACTIONATOR WARNING #### Set game state name and value arrays are not the same size in: " + name)


func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	
	if only_on_game_state_name.size() > 0 and only_on_game_state_value.size() > 0:
		for i in range(only_on_game_state_name.size()):
			if GameState.get(only_on_game_state_name[i]) != only_on_game_state_value[i]:
				return

	if dialogue_string != "":
		DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_string)
	
	for i in range(set_game_state_name.size()):
		GameState.set(set_game_state_name[i], set_game_state_value[i])

	if only_use_once:
		queue_free()
