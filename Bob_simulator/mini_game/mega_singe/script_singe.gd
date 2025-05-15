extends Node2D

@onready var mini_game_core = $".."
var game_is_start = false
@onready var start_bg_anime = $bg_menu/anime_menu
@onready var player = $Area2D2
@export var player_gravity = 210
@onready var player_animation = $Area2D2/AnimationPlayer
@onready var player_animation_jump = $Area2D2/jump
@onready var player_sprite = $Area2D2/Sprite2D

var player_speed = 2
#@onready var player = $Area2D2
func _ready() -> void:
	start_bg_anime.play("start")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if game_is_start :
		if Input.is_action_just_pressed("interact") :
			player_animation_jump.play("gravity_change")
		if Input.is_action_pressed("left"):
			player.position.x -= player_speed
			player_animation.play("run")
			player_sprite.flip_h = true
		elif Input.is_action_pressed("right"):
			player.position.x += player_speed
			player_animation.play("run")
			player_sprite.flip_h = false
		else :
			player_animation.play("idle")
		player.position.x = clamp(player.position.x,0,256)
		player.position.y = player_gravity
	
	if not game_is_start :
		if Input.is_action_just_pressed("interact"):
			start_bg_anime.play("game_start")
			game_is_start = true
	if Input.is_action_just_pressed("run"):
		mini_game_core.quit_mini_game()
