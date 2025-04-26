extends CharacterBody2D


var speed = 2000.0
const JUMP_VELOCITY = -400.0
@onready var hitbox = $Area2D
@onready var timer = $Timer

func dash(direction):
	hitbox.set_process(true)
	timer.start()
	velocity = direction * speed
	

func _physics_process(_delta: float) -> void:
	velocity /= 2
	position = round(position)
	move_and_slide()


func hit(body: Node2D) -> void:
	print(hit)


func _on_timer_timeout() -> void:
	hitbox.set_process(false)
