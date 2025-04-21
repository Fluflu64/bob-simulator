class_name Interactable
extends Area2D

@export var lines:Array[String] = ["oui","oui"]
@export var sprite_hide:bool = true
@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D

func _ready():
	if sprite_hide :
		sprite.hide()

func end_talk():
	animation.play("stop")
