class_name Interactable
extends Area2D

@export var lines = ["oui","oui"]
@export var hide:bool = true
@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D

func _ready():
	if hide :
		sprite.hide()

func end_talk():
	print("oui")
	animation.play("stop")
