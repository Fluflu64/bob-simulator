extends Area2D
class_name Push

var is_moving = false 

@onready var parent = $".."

func _process(_delta: float) -> void:
	is_moving = parent.dust.emitting 
