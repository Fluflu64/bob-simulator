extends Node2D


var dodge_event = false
var player_has_dodge = false
@onready var animation_player = $bob_anim
@onready var animation_flic = $flic_anim

@onready var battle_menu = null

@onready var timer = $dodge_timer

func _ready() -> void:
	animation_flic.play("attack")
	await animation_flic.animation_finished
	if player_has_dodge :
		battle_menu.ennemi_attack_result = 0
	else :
		battle_menu.ennemi_attack_result = 1
	queue_free()

func _process(_delta: float) -> void:
	if dodge_event :
		if Input.is_action_just_pressed("interact") and not player_has_dodge:
			animation_player.play("dodge")
			player_has_dodge = true


func start_dodge():
	timer.start()
	dodge_event = true


func _on_dodge_timer_timeout() -> void:
	dodge_event = false
	if not player_has_dodge :
		animation_player.play("kill")
