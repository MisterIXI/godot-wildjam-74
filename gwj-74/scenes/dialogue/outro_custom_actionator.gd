extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	if GameState.has_ticked:
		GameManager.main.color_screen.start_dialog("outro")
		queue_free()
	


