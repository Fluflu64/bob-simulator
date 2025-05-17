extends Node2D
var game_pause = false
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
var is_boss = false
var boss_hit = false
var bossx = 0
@onready var bulet = preload("res://Bob_simulator/mini_game/mega_singe/scn_mega_bullet_du_flingue_du_mega_singe_de_lamortkiuetou.tscn")

@onready var bsd = $Area2D
var is_get = false

var score = 29
var life = 29
var boss = 100

var player_speed = 2

func spawn_bsd():
	bsd.position = Vector2(randi_range(8,248),randi_range(8,193))

func _ready() -> void:
	start_bg_anime.play("start")
	$Area2D3/AnimationPlayer2.play("fpchimer")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not game_pause :
		$NinePatchRect/Label.text = \
		"score : " + str(score) +"\nlife : " + str(life) + "\nboss : " + str(boss)
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
		fpchimer_sprite.scale.x = -sign(fpchimer.position.x - player.position.x)
		if boss_hit and is_boss:
			boss -= 1
			if boss <= 0 :
				game_pause = true
				$NinePatchRect2/Label.text = "bravo\nvotre score est :\n" + str(score)
				$NinePatchRect2.show()
				$Area2D.hide()
				bossx = fpchimer.position.x
				fpchimer_sprite.flip_v = true
				player_sprite.flip_h = not player_sprite.flip_h
				player_animation.play("run")
	else :
		fpchimer.position.x = bossx + randi_range(-2,2) 
		fpchimer.position.y += 1
		if player_sprite.flip_h :
			player.position.x -= 1
		else :
			player.position.x += 1
		if Input.is_action_just_pressed("run"):
			mini_game_core.quit_mini_game()

func move_fp():
	if not fpchimer_is_move :
		fpchimer_is_move = true
		pos_A = fpchimer.global_position
		pos_B = Vector2(randi_range(12,244),randi_range(12,244))
		move_fp_anim.play("move")
		await move_fp_anim.animation_finished
		fpchimer_is_move = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if not is_get :
		if area == player or area is Mega_bulet:
			is_get = true
			$Area2D/AnimationPlayer.play("rotate")
			await $Area2D/AnimationPlayer.animation_finished
			spawn_bsd()
			score += 1
			life += 1
			if score >= 30 and not is_boss:
				$Area2D3/AnimationPlayer2.play("boss")
				is_boss = true
			if area != null :
				if area is Mega_bulet :
					area.queue_free()
			is_get = false
		


func _on_area_2d_3_area_entered(area: Area2D) -> void:
	if area == player or area is Mega_bulet:
		if area == player :
			if not is_boss :
				score -= 1
			if is_boss :
				life -= 5
		if area != null :
			if area is Mega_bulet and not is_boss:
				area.queue_free()
			if area is Mega_bulet and is_boss:
				boss_hit = true

func _on_area_2d_3_area_exited(area: Area2D) -> void:
	if area != null :
		if area is Mega_bulet and is_boss:
			boss_hit = false
