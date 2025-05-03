class_name Battle_Bob
extends CharacterBody2D

const base_speed = 4000.0

var speed = base_speed
const JUMP_VELOCITY = -400.0
@onready var hitbox = $Area2D
@onready var collision = $CollisionShape2D
@onready var timer = $Timer
@onready var timer2 = $Timer2
@onready var sprite = $TexBob
@onready var animation = $AnimationPlayer
@onready var particle = $CPUParticles2D
@onready var target = $target

@onready var timer_turn = $Timer3

@onready var menu_stats = $action_border
@onready var label_stats = $action_border/action_label

#stats
@export var hostil = true

@export var nom = "???"

@export var pv = 10
var max_pv = pv

@export var base_atk = 1.0
var atk = base_atk

@export var base_dfs = 1.0
var dfs = base_dfs

signal hit_body()
signal turn_end

'''
if index_actions_menu == 0 :#punch
		attack = ceil(player_atk / ennemi_dfs)
		ennemi_battle.speed /= 1.8
		histo.append("bob atk " + str(attack))
	if index_actions_menu == 1:#stun
		attack = ceil((player_atk/2) / ennemi_dfs)
		histo.append("bob atk " + str(attack))
		player_battle.dash(direction_attack*-1)
		ennemi_battle.speed = 1
		histo.append(ennemi_name + " est immobilisé")
	if index_actions_menu == 2 :#STOP
		attack = ennemei_pv
		histo.append("STOOOOP")
	ennemei_pv -= attack
'''
func dash(direction):
	velocity = direction * speed
	speed = (speed*4+base_speed)/5

func hit(body: Node2D) -> void:
	if body is Battle_Bob and body != self:
		if not (hostil and body.hostil) :
			var direction = (position -body.position).normalized()*1000
			body.knockback(direction)
			body.pv -= 1
			hit_body.emit()

func knockback(direction):
	particle.emitting = true
	timer2.start()
	sprite.offset.x = 16
	sprite.self_modulate = Color(1,0,0,1)
	velocity = direction

func _physics_process(_delta: float) -> void:
	velocity /= 2
	position = round(position)
	move_and_slide()
	label_stats.text = str(pv) + "/" + str(max_pv)

func _on_timer_timeout() -> void:
	sprite.offset.x *= -0.5
	sprite.self_modulate = (sprite.self_modulate+ Color(1,1,1,1))/2
	sprite.offset.x = roundf(sprite.offset.x)
	if abs(sprite.offset.x) == 1 :
		sprite.offset.x = 0
		sprite.self_modulate = Color(1,1,1,1)

func stop_particle() -> void:
	particle.emitting = false

func turn_start():
	timer_turn.start()
	hitbox.set_process_mode(PROCESS_MODE_INHERIT)

func ia_move(player):
	if pv > 0 :
		turn_start()
		var random_move = randi_range(0,1)
		if random_move == 0:
			backward(player)
		if random_move == 1:
			punch(player)
	else :
		turn_end.emit()

func backward(ennemi_target):
	if pv > 0 :
		turn_start()
		var dash_direction = (position - ennemi_target.position).normalized()
		dash(dash_direction)
	else :
		turn_end.emit()

func punch(ennemi_target):
	if pv > 0 :
		turn_start()
		var dash_direction = (ennemi_target.position - position).normalized()
		dash(dash_direction)
	else :
		turn_end.emit()


func my_turn_end() -> void:
	hitbox.set_process_mode(PROCESS_MODE_DISABLED)
	turn_end.emit()
