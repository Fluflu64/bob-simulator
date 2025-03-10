class_name Interactable
extends Area2D

@export var lines = ["oui","oui"]
@onready var animation = $AnimationPlayer

func end_talk():
	print("oui")
	animation.play("stop")
