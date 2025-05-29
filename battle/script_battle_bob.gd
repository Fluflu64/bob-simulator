class_name Battle_Bob
extends Node2D



@onready var sprite2 = $action_border/TexBob
@onready var animation = $AnimationPlayer
@onready var target = $target
@onready var label_name = $action_border/Label

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


func _ready() -> void:
	label_name.text = nom


func _physics_process(_delta: float) -> void:
	stat_health.frame = clamp(int((float(pv) * 14.0) / float(max_pv)),0,14)

func degat(hit_target,hit_value):
	hit_target.pv -= hit_value
	if hit_target.pv <= 0 :
		hit_target.animation.play("lose")


func turn_start():
	timer_turn.start()

func ia_move(player,atk_result):
	if pv > 0 :
		turn_start()
		if atk_result == 0:
			animation.play("miss")
		if atk_result == 1:
			punch(player)
	else :
		turn_end.emit()

func player_move(ennemi,atk_result):
	if pv > 0 :
		turn_start()
		if atk_result == 1:
			animation.play("miss")
		if atk_result == 0:
			punch(ennemi)
	else :
		turn_end.emit()

func punch(ennemi_target):
	animation.play("punch")
	degat(ennemi_target,1)
	turn_end.emit()


func my_turn_end() -> void:
	turn_end.emit()
