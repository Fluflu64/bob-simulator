extends Node2D


var dodge_event = false
var player_has_dodge = false
var atk_fail = false
@onready var animation_player = $AnimationPlayer

@onready var battle_menu = null

@onready var timer = $Timer

@onready var global_timer = $Timer2

func _ready() -> void:
	global_timer.start()
	animation_player.play("punch")
	await global_timer.timeout
	if player_has_dodge :
		battle_menu.ennemi_attack_result = 0
	else :
		battle_menu.ennemi_attack_result = 1
	queue_free()

func _process(_delta: float) -> void:
	if dodge_event :
		if Input.is_action_just_pressed("interact") and not player_has_dodge:
			animation_player.play("win")
			player_has_dodge = true
	else :
		if Input.is_action_just_pressed("interact") :
			atk_fail = true
			animation_player.play("tot")


func start_dodge():
	if not atk_fail :
		timer.start()
		dodge_event = true


func _on_dodge_timer_timeout() -> void:
	dodge_event = false
	if not player_has_dodge :
		animation_player.play("fail")
