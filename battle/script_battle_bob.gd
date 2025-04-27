class_name Battle_Bob
extends CharacterBody2D

const base_speed = 4000

var speed = base_speed
const JUMP_VELOCITY = -400.0
@onready var hitbox = $Area2D
@onready var collision = $CollisionShape2D
@onready var timer = $Timer
@onready var sprite = $TexBob
@onready var animation = $AnimationPlayer
@export var debug = "oui"

signal hit_body()

func dash(direction):
	velocity = direction * speed
	speed = (speed*4+base_speed)/5

func knockback(direction):
	sprite.offset.x = 16
	sprite.self_modulate = Color(1,0,0,1)
	velocity = direction
	

func _physics_process(_delta: float) -> void:
	velocity /= 2
	position = round(position)
	move_and_slide()


func hit(body: Node2D) -> void:
	if body is Battle_Bob and body != self:
		hit_body.emit()


func _on_timer_timeout() -> void:
	sprite.offset.x *= -0.5
	sprite.self_modulate = (sprite.self_modulate+ Color(1,1,1,1))/2
	sprite.offset.x = roundf(sprite.offset.x)
	if abs(sprite.offset.x) == 1 :
		sprite.offset.x = 0
		sprite.self_modulate = Color(1,1,1,1)
	
