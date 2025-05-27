class_name Battle_Bob
extends Node2D


@onready var timer = $Timer
@onready var timer2 = $Timer2
@onready var sprite = $action_border/TexBob
@onready var animation = $AnimationPlayer
@onready var target = $target

@onready var timer_turn = $Timer3

@onready var menu_stats = $action_border

@onready var stat_health = $action_border/Sprite2D
#stats
@export var hostil = true

@export var nom = "???"

@export var pv = 10
var max_pv = pv

@export var base_atk = 1.0
var atk = base_atk

@export var base_dfs = 1.0
var dfs = base_dfs

signal hit_body
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
	ennemei_pv -= attackfe
'''





func _physics_process(_delta: float) -> void:
	stat_health.frame = clamp(int((float(pv) * 14.0) / float(max_pv)),0,14)

func _on_timer_timeout() -> void:
	sprite.offset.x *= -0.5
	sprite.self_modulate = (sprite.self_modulate+ Color(1,1,1,1))/2
	sprite.offset.x = roundf(sprite.offset.x)
	if abs(sprite.offset.x) == 1 :
		sprite.offset.x = 0
		sprite.self_modulate = Color(1,1,1,1)

func degat(hit_target,hit_value):
	hit_target.pv -= hit_value
	if hit_target.pv <= 0 :
		hit_target.animation.play("lose")


func turn_start():
	timer_turn.start()

func ia_move(player):
	if pv > 0 :
		turn_start()
		var random_move = randi_range(0,1)
		if random_move == 0:
			punch(player)
		if random_move == 1:
			pass
	else :
		turn_end.emit()



func punch(ennemi_target):
	animation.play("punch")
	degat(ennemi_target,1)
	print("atk")
	turn_end.emit()


func my_turn_end() -> void:
	turn_end.emit()
