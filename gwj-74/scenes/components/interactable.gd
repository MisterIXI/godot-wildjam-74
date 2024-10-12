class_name Interactable
extends StaticBody2D

signal interacted


func interact() -> void:
	interacted.emit()
