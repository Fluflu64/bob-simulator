extends Node2D

@onready var mini_game_core = $".."
var game_is_start = false
@onready var start_bg_anime = $bg_menu/anime_menu
@onready var player = $Area2D2
@export var player_gravity = 210
@onready var player_animation = $Area2D2/AnimationPlayer
@onready var player_animation_jump = $Area2D2/jump
@onready var player_sprite = $Area2D2/Sprite2D
@onready var fpchimer = $Area2D3
@onready var fpchimer_sprite = $Area2D3/Sprite2D
var fpchimer_is_move = false
var pos_A = Vector2.ZERO
var pos_B = Vector2.ZERO
@export var lerp_pos:float = 0.0
@onready var move_fp_anim = $Area2D3/AnimationPlayer

@onready var bulet = preload("res://Bob_simulator/mini_game/mega_singe/scn_mega_bullet_du_flingue_du_mega_singe_de_lamortkiuetou.tscn")

@onready var bsd = $Area2D

var player_speed = 2

func spawn_bsd():
	bsd.position = Vector2(randi_range(8,248),randi_range(8,193))

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
		
		if Input.is_action_just_pressed("up"):
			var instance_bulet = bulet.instantiate()
			instance_bulet.position = player.position
			$".".add_child(instance_bulet)
	
	if not game_is_start :
		if Input.is_action_just_pressed("interact"):
			start_bg_anime.play("game_start")
			game_is_start = true
	if Input.is_action_just_pressed("run"):
		mini_game_core.quit_mini_game()
	
	move_fp()
	fpchimer.global_position.x = round(lerp(pos_A.x,pos_B.x,move_fp_anim.current_animation_position))
	fpchimer.global_position.y = round(lerp(pos_A.y,pos_B.y,move_fp_anim.current_animation_position))
	

func move_fp():
	if not fpchimer_is_move :
		fpchimer_is_move = true
		pos_A = fpchimer.global_position
		pos_B = Vector2(randi_range(12,244),randi_range(12,244))
		move_fp_anim.play("move")
		await move_fp_anim.animation_finished
		fpchimer_is_move = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area == player or area is Mega_bulet:
		spawn_bsd()
		if area is Mega_bulet :
			area.queue_free()
		


func _on_area_2d_3_area_entered(area: Area2D) -> void:
	if area == player or area is Mega_bulet:
		if area is Mega_bulet :
			area.queue_free()
