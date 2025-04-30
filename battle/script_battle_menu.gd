extends Node2D

@onready var animation = $shader_circle/animation_interface
@onready var battle_anime = $animation_battle
@onready var stats_label = $background/health_border/health_label
@onready var battle_menu = $background/action_border/action_label
@onready var action_menu = $background/action_border2/action_label
@onready var circle = $shader_circle
@onready var label_histo = $background/historic_border/historic_label
@onready var music = $AudioStreamPlayer2D/AudioStreamPlayer
@onready var battle_area = $TexBattleArena
@onready var submenu = $background/action_border2

var music_to_play = null

@export var game_root = null
@export var player = null

@export var music_battle = AudioStream

#stats player
@onready var player_battle = $TexBattleArena/CharacterBody2D
var player_pv = 20
var max_player_pv = 20
var player_atk = 2.0
var player_dfs = 2.0
var player_dfs_base = player_dfs

#stats ennemi
@onready var ennemi_battle = $TexBattleArena/CharacterBody2D2
var ennemi_name = "flic"
var ennemei_pv = 10
var max_ennemie_pv = 10
var ennemi_atk = 2.0
var ennemi_dfs = 1.0

var histo = [\
"",
"",
"",
"",
"",
]

var tour = 0
var battle_lock = false

var label_menu = ["attack","action","item","flee"]
var action_label = ["↑ ","← ","↓ ","→ ","defense"]
var attack_label = ["punch","stun","STOP"]
var label_actions_menu = []
var text_select = "<"
var index_menu = 0
var index_actions_menu = 0
var action_menu_check = false

func update_player():
	player.pv = player_pv
	player.pv_max = max_player_pv
	player.atk = player_atk
	player.def = player_dfs

func func_menu(index):
	if index == 0 :
		battle_lock = true
		label_actions_menu = attack_label
		update_actions()
		index_actions_menu = 0
		action_menu_check = true
		animation.play("menu_show")
		await animation.animation_finished
		submenu.show()
		index_menu = 9

	if index == 1 :
		battle_lock = true
		label_actions_menu = action_label
		update_actions()
		index_actions_menu = 0
		action_menu_check = true
		animation.play("menu_show")
		await animation.animation_finished
		submenu.show()
		index_menu = 10
	
	if index == 2 :
		histo.append("tu n'as pas d'objet")
		update_histo()
	
	if index == 3 :
		battle_lock = true
		histo.append("bob fuit")
		update_histo()
		player_battle.animation.play("flee")
		animation.play("menu_show")
		await animation.animation_finished
		if randi_range(0,3)==2:
			
			
			battle_anime.play("player_flee_win")
			await battle_anime.animation_finished
			player_battle.collision.disabled = true
			player_battle.dash(Vector2(0,1.5))
			animation.play("battle end_flee")
			await animation.animation_finished
			update_player()
			game_root.end_battle()
			queue_free()
		else :
			
			battle_anime.play("player_flee_lose")
			await battle_anime.animation_finished
			player_battle.dash(Vector2(0,0.2))
			histo.append("ça à échouer")
			player_battle.animation.play("flee_lose")
			await player_battle.animation.animation_finished
		
			battle_lock = false
			tour = 1
		update_histo()

func hit_ennemy():
	var attack = 0
	var direction_attack = (ennemi_battle.position - player_battle.position).normalized()
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
	
	update_histo()
	
	ennemi_battle.knockback(direction_attack*2000)

func hit_player():
	var attack = ceil(ennemi_atk / player_dfs)
	player_pv -= attack
	histo.append(str(ennemi_name) + " atk " + str(attack))
	player_battle.speed /= 1.5
	update_histo()
	var direction_attack = (player_battle.position - ennemi_battle.position).normalized()
	player_battle.knockback(direction_attack*2000)

func _ready() -> void:
	player_battle.hit_body.connect(hit_ennemy)
	ennemi_battle.hit_body.connect(hit_player)
	submenu.hide()
	update_histo()
	update_menu()
	update_actions()
	circle.show()
	animation.play("battle start")
	index_menu = 0
	
	update_menu()
	

func is_select(button_index,menu_for_index) :
	if button_index == menu_for_index :
		return text_select
	else :
		return ""

func update_histo():
	var text = ""
	for i in range(len(histo)-5,len(histo)) :
		text += histo[i] + "\n"
	label_histo.text = text

func update_menu():
	var text = ""
	for i in range(len(label_menu)) :
		text += label_menu[i] + is_select(i,index_menu) + "\n"
	battle_menu.text = text

func update_actions():
	var text = ""
	for i in range(len(label_actions_menu)) :
		text += label_actions_menu[i] + is_select(i,index_actions_menu) + "\n"
	action_menu.text = text

func _input(event: InputEvent) -> void:
	if not battle_lock :
		if event.is_action_pressed("down") :
			index_menu += 1
		
		if event.is_action_pressed("up") :
			index_menu -= 1
			
		
		if index_menu < 0 :
			index_menu = 0
		if index_menu > len(label_menu)-1 :
			index_menu = len(label_menu)-1
		
	
	if action_menu_check :
		if event.is_action_pressed("down") :
			index_actions_menu += 1
		if event.is_action_pressed("up") :
			index_actions_menu -= 1
		
		if index_actions_menu < 0 :
			index_actions_menu = 0
		if index_actions_menu > len(label_actions_menu)-1 :
			index_actions_menu = len(label_actions_menu)-1
		
		if event.is_action_pressed("left") :
			pass
	update_menu()
	update_actions()
	update_histo()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	player_battle.sprite.scale.x = sign(ennemi_battle.position.x - player_battle.position.x)
	ennemi_battle.sprite.scale.x = sign(player_battle.position.x - ennemi_battle.position.x)
	stats_label.text = "bob : pv "+str(player_pv)+"/"+ str(max_player_pv) +" \n" + ennemi_name + " : pv " + str(ennemei_pv)+"/"+ str(max_ennemie_pv)
		
	if index_menu == 9 :
		if Input.is_action_just_pressed("interact") :
			index_menu = 0
			submenu.hide()
			player_battle.animation.play("punch")
			var direction_attack = (ennemi_battle.position - player_battle.position).normalized()
			if index_actions_menu == 0 :
				player_battle.dash(direction_attack*1)
			if index_actions_menu == 1 :
				player_battle.dash(direction_attack*1.5)
			if index_actions_menu == 2 :
				player_battle.dash(direction_attack*2)
			player_battle.hitbox.set_process_mode(PROCESS_MODE_INHERIT)
			battle_anime.play("move")
			await battle_anime.animation_finished
			
			
			player_battle.animation.play("idle")
			battle_anime.play("move")
			await battle_anime.animation_finished
			action_menu_check = false
			battle_lock = false
			tour = 1
			
			player_battle.hitbox.set_process_mode(PROCESS_MODE_DISABLED)
	
	if index_menu == 10 :
		if Input.is_action_just_pressed("interact") :
			index_menu = 1
			submenu.hide()
			if index_actions_menu == 0 :
				player_battle.dash(Vector2(0,-1))
			if index_actions_menu == 1 :
				player_battle.dash(Vector2(-1,0))
			if index_actions_menu == 2 :
				player_battle.dash(Vector2(0,1))
			if index_actions_menu == 3 :
				player_battle.dash(Vector2(1,0))
			if index_actions_menu == 4 :
				var direction_attack = (player_battle.position - ennemi_battle.position).normalized()
				player_battle.dash(direction_attack*2)
			battle_anime.play("move")
			await battle_anime.animation_finished
			action_menu_check = false
			battle_lock = false
			tour = 1
			player_battle.animation.play("idle")
			ennemi_battle.animation.play("idle")
			player_battle.hitbox.set_process_mode(PROCESS_MODE_DISABLED)
	
	if index_menu == 9 or index_menu == 10 :
		if Input.is_action_just_pressed("run") :
			if index_menu == 9 :
				index_menu = 0
			if index_menu == 10 :
				index_menu = 1
			battle_lock = false
			action_menu_check = false
			submenu.hide()
			update_menu()
			animation.play_backwards("menu_show")
			await animation.animation_finished
	
	if not battle_lock :
		if ennemei_pv <= 0 or player_pv <= 0:
				battle_lock = true
				
				if player_pv <= 0 :
					battle_anime.play("player_down")
					ennemi_battle.animation.play("win")
					player_battle.animation.play("lose")
					await battle_anime.animation_finished
				else :
					battle_anime.play("player_win")
					ennemi_battle.animation.play("lose")
					player_battle.animation.play("win")
					await battle_anime.animation_finished
				
				animation.play("battle end")
				await animation.animation_finished
				
				update_player()
				
				game_root.end_battle()
				queue_free()
				
		elif tour == 0:
			if Input.is_action_just_pressed("interact") :
				ennemi_battle.hitbox.set_process_mode(PROCESS_MODE_DISABLED)
				func_menu(index_menu)
				
		elif tour == 1:
			ennemi_battle.animation.play("punch")
			player_battle.hitbox.set_process_mode(PROCESS_MODE_DISABLED)
			battle_lock = true
			ennemi_battle.hitbox.set_process_mode(PROCESS_MODE_INHERIT)
			var direction_attack = (player_battle.position - ennemi_battle.position).normalized()
			ennemi_battle.dash(direction_attack*.5)
			battle_anime.play("move")
			await battle_anime.animation_finished
			
			
			
			battle_anime.play("move")
			await battle_anime.animation_finished
			
			animation.play_backwards("menu_show")
			await animation.animation_finished
			
			battle_lock = false
			tour = 0
			player_battle.animation.play("idle")
			ennemi_battle.animation.play("idle")
			ennemi_battle.hitbox.set_process_mode(PROCESS_MODE_DISABLED)
