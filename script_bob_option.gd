extends Node2D

@onready var animation = $AnimationPlayer

var speed = 0
var move = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("right")
