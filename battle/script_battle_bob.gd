extends CharacterBody2D


var speed = 2000.0
const JUMP_VELOCITY = -400.0


func dash(direction):
	velocity = direction * speed

func _physics_process(_delta: float) -> void:
	velocity /= 2
	position = round(position)
	move_and_slide()
