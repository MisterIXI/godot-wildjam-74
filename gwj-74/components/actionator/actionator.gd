@icon("res://components/actionator/actionator.png")
extends Area2D
class_name Actionator


@export_group("General")
## Only use the actionator once. It will destroy itself after the first use.
@export var only_use_once : bool = false
## Only activate the actionator if the some specific game states are set to a specific value.
@export var only_on_game_state_name  : Array[String] = []
@export var only_on_game_state_value : Array[bool] = []



@export_group("Dialogue")
## Activate the dialogue activator
@export var start_dialogue : bool = false
## The string name of the dialogue
@export var dialogue_string : String = ""
@export var dialogue_resource : DialogueResource = null


@export_group("Game State")
## Change the game state variables.
@export var set_game_state_name : Array[String] = []
@export var set_game_state_value : Array[bool] = []


@export_group("Cutscene")
## Activate the cutscene CURRENTLY NOT IMPLEMENTED
@export var start_cutscene : bool = false


func _ready() -> void:
	body_entered.connect(_on_body_entered)

	if start_dialogue and dialogue_string == "":
		print("### ACTIONATOR WARNING #### Dialogue string is empty in: " + name)

	if only_on_game_state_name.size() > 0 and only_on_game_state_value.size() > 0:
		if only_on_game_state_name.size() != only_on_game_state_value.size():
			print("### ACTIONATOR WARNING #### Game state name and value arrays are not the same size in: " + name)
	
	if start_cutscene:
		print("### ACTIONATOR WARNING #### Cutscene is not implemented yet in: " + name)


func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	
	if only_on_game_state_name.size() > 0 and only_on_game_state_value.size() > 0:
		for i in range(only_on_game_state_name.size()):
			if GameState.get(only_on_game_state_name[i]) != only_on_game_state_value[i]:
				return

	if start_dialogue:
		DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_string)
	
	for i in range(set_game_state_name.size()):
		GameState.set(set_game_state_name[i], set_game_state_value[i])

	if only_use_once:
		queue_free()
