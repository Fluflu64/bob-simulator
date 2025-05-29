extends Node2D

@onready var animation = $shader_circle/animation_interface
@onready var battle_anime = $animation_battle
@onready var battle_menu = $background/action_border/action_label
@onready var action_menu = $background/action_border2/action_label
@onready var circle = $shader_circle
@onready var label_histo = $background/historic_border/historic_label
@onready var music = $AudioStreamPlayer2D/AudioStreamPlayer
@onready var battle_area = $TexBattleArena
@onready var submenu = $background/action_border2
@onready var hand = $TexBattleArena/Node2D

@onready var turn_time = $turn_timer

var music_to_play = null

@export var game_root = null
@export var player = null

@export var music_battle = AudioStream

#stats player
@onready var player_battle = $TexBattleArena/bob
var player_pv = 1
var max_player_pv = 1
var player_atk = 1
var player_dfs = 1

var list_attack_player = [\
preload("res://battle/scn_bob_punch.tscn")]

#stats ennemi
@onready var ennemis_battle = []
var ennemi_attack_result = 0

var histo = [\
"",
"",
"",
"",
"",
]

var tour = 0
var battle_lock = true

var label_menu = [172,202,232,289]

var attack_label = [174,175,176]
var action_label = [204,205,206,207,208]

var label_actions_menu = []
var text_select = "<"
var index_menu = 0
var index_actions_menu = 0
var action_menu_check = false

var list_attack = [\
preload("res://battle/attack/scn_ennemi_attack_base.tscn"),
preload("res://battle/attack/scn_atk_flic_000.tscn")]

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
		player_battle.pv = player_battle.max_pv
		histo.append("tu es heal")
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
			animation.play("battle end_flee")
			await animation.animation_finished
			game_root.end_battle()
			queue_free()
		else :
			
			battle_anime.play("player_flee_lose")
			await battle_anime.animation_finished
			histo.append("ça à échouer")
			player_battle.animation.play("flee_lose")
			await player_battle.animation.animation_finished
		
			battle_lock = false
			tour = 1
		update_histo()

func hit_ennemy():
	
	update_histo()

func hit_player():
	
	update_histo()

func _ready() -> void:
	update_ennemi()
	
	#player_battle.hit_body.connect(hit_ennemy)
	
	submenu.hide()
	update_histo()
	update_menu()
	update_actions()
	circle.show()
	animation.play("battle start")
	index_menu = 0
	
	
	update_menu()
	await animation.animation_finished
	battle_lock = false
	
func distance_bteween_2(pos1,pos2):
	return sqrt((pos1.x-pos2.x)**2+(pos1.y-pos2.y)**2)

func is_select(button_index,menu_for_index) :
	if button_index == menu_for_index :
		return text_select
	else :
		return ""

func update_ennemi():
	ennemis_battle = []
	for child in battle_area.get_children() :
		if child is Battle_Bob :
			if child.hostil and child.pv > 0:
				ennemis_battle.append(child)
				

func update_histo():
	var text = ""
	for i in range(len(histo)-5,len(histo)) :
		text += histo[i] + "\n"
	label_histo.text = text

func update_menu():
	var text = ""
	for i in range(len(label_menu)) :
		text += BobGlobal.langue[BobGlobal.langindex][label_menu[i]] + is_select(i,index_menu) + "\n"
	battle_menu.text = text

func update_actions():
	var text = ""
	for i in range(len(label_actions_menu)) :
		if label_actions_menu[i] is int :
			text += BobGlobal.langue[BobGlobal.langindex][label_actions_menu[i]] + is_select(i,index_actions_menu) + "\n"
		else :
			text += label_actions_menu[i] + is_select(i,index_actions_menu) + "\n"
	action_menu.text = text

func _input(_event: InputEvent) -> void:
	if not battle_lock :
		if Input.is_action_just_pressed("down") :
			index_menu += 1
		
		if Input.is_action_just_pressed("up") :
			index_menu -= 1
			
		
		if index_menu < 0 :
			index_menu = 0
		if index_menu > len(label_menu)-1 :
			index_menu = len(label_menu)-1
		
	
	if action_menu_check :
		if index_menu != 11 :
			if Input.is_action_just_pressed("down") :
				index_actions_menu += 1
			if Input.is_action_just_pressed("up") :
				index_actions_menu -= 1
			
			if index_actions_menu < 0 :
				index_actions_menu = 0
			if index_actions_menu > len(label_actions_menu)-1 :
				index_actions_menu = len(label_actions_menu)-1
			
			if Input.is_action_just_pressed("left") :
				pass
		else :
			
			
			if Input.is_action_just_pressed("down") :
				var temp = ennemis_battle[index_actions_menu].position
				var distemp = null
				for ennemi in range(len(ennemis_battle)) :
					if ennemis_battle[ennemi].position.y > temp.y :
						if distemp == null :
							distemp = distance_bteween_2(temp,ennemis_battle[ennemi].position)
							index_actions_menu = ennemi
						elif distance_bteween_2(temp,ennemis_battle[ennemi].position) < distemp :
							distemp = distance_bteween_2(temp,ennemis_battle[ennemi].position)
							index_actions_menu = ennemi
						
			if Input.is_action_just_pressed("up") :
				var temp = ennemis_battle[index_actions_menu].position
				var distemp = null
				for ennemi in range(len(ennemis_battle)) :
					if ennemis_battle[ennemi].position.y < temp.y :
						if distemp == null :
							distemp = distance_bteween_2(temp,ennemis_battle[ennemi].position)
							index_actions_menu = ennemi
						elif distance_bteween_2(temp,ennemis_battle[ennemi].position) < distemp :
							distemp = distance_bteween_2(temp,ennemis_battle[ennemi].position)
							index_actions_menu = ennemi
			
			if Input.is_action_just_pressed("right") :
				var temp = ennemis_battle[index_actions_menu].position
				var distemp = null
				for ennemi in range(len(ennemis_battle)) :
					if ennemis_battle[ennemi].position.x > temp.x :
						if distemp == null :
							distemp = distance_bteween_2(temp,ennemis_battle[ennemi].position)
							index_actions_menu = ennemi
						elif distance_bteween_2(temp,ennemis_battle[ennemi].position) < distemp :
							distemp = distance_bteween_2(temp,ennemis_battle[ennemi].position)
							index_actions_menu = ennemi
			if Input.is_action_just_pressed("left") :
				var temp = ennemis_battle[index_actions_menu].position
				var distemp = null
				for ennemi in range(len(ennemis_battle)) :
					if ennemis_battle[ennemi].position.x < temp.x :
						if distemp == null :
							distemp = distance_bteween_2(temp,ennemis_battle[ennemi].position)
							index_actions_menu = ennemi
						elif distance_bteween_2(temp,ennemis_battle[ennemi].position) < distemp :
							distemp = distance_bteween_2(temp,ennemis_battle[ennemi].position)
							index_actions_menu = ennemi
	update_menu()
	update_actions()
	update_histo()
	update_ennemi()

func _process(_delta: float) -> void:
	if index_menu == 11 :
		hand.global_position = round(lerp(hand.global_position,ennemis_battle[index_actions_menu].target.global_position,.8))
	
	
	if index_menu == 9 :
		if Input.is_action_just_pressed("interact") :
			ennemis_battle = []
			for child in battle_area.get_children() :
				if child is Battle_Bob :
					if child.hostil :
						ennemis_battle.append(child)
			var label_ennemi = []
			for ennemi in ennemis_battle :
				label_ennemi.append(ennemi.nom)
			label_actions_menu = label_ennemi
			animation.play("select_opponent")
			await animation.animation_finished
			submenu.position = Vector2(-128,-72)
			index_menu = 11
			index_actions_menu = 0
			submenu.hide()
			hand.show()
			update_actions()
			

	if index_menu == 11 :
		if Input.is_action_just_pressed("interact") :
			index_menu = 0
			submenu.hide()
			battle_anime.play("move")
			await battle_anime.animation_finished
			turn_time.start()
			var instance_attack = list_attack_player[0].instantiate()
			add_child(instance_attack)
			instance_attack.battle_menu = self
			await instance_attack.tree_exited
			player_battle.player_move(ennemis_battle[index_actions_menu],ennemi_attack_result)
			battle_anime.play("move")
			await battle_anime.animation_finished
			action_menu_check = false
			battle_lock = false
			tour = 1
			hand.hide()

	
	if index_menu == 10 :
		if Input.is_action_just_pressed("interact") :
			index_menu = 1
			submenu.hide()
			battle_anime.play("move")
			await battle_anime.animation_finished
			action_menu_check = false
			battle_lock = false
			tour = 1
	
	if index_menu == 9 or index_menu == 10 or index_menu == 11 :
		if Input.is_action_just_pressed("run") :
			if index_menu == 9 :
				index_menu = 0
				battle_lock = false
				action_menu_check = false
				submenu.hide()
				animation.play_backwards("menu_show")
				await animation.animation_finished
				
			if index_menu == 10 :
				index_menu = 1
				battle_lock = false
				action_menu_check = false
				submenu.hide()
				animation.play_backwards("menu_show")
				await animation.animation_finished
			
			if index_menu == 11 :
				index_menu = 9
				index_actions_menu = 0
				battle_lock = true
				action_menu_check = true
				label_actions_menu = attack_label
				hand.hide()
				update_actions()
				submenu.show()
			update_menu()
			
			
	
	if not battle_lock :#death
		var all_ennemi_is_dead = true
		for ennemi in ennemis_battle :
			if ennemi.pv > 0 :
				all_ennemi_is_dead = false
		
		if all_ennemi_is_dead or player_battle.pv <= 0:
				battle_lock = true
				
				if player_battle.pv <= 0 :
					battle_anime.play("player_down")
					for ennemi in ennemis_battle :
						ennemi.animation.play("win")
					player_battle.animation.play("lose")
					await battle_anime.animation_finished
				else :
					battle_anime.play("player_win")
					for ennemi in ennemis_battle :
						ennemi.animation.play("lose")
					player_battle.animation.play("win")
					await battle_anime.animation_finished
				
				animation.play("battle end")
				await animation.animation_finished
				
				game_root.end_battle()
				queue_free()
				
		elif tour == 0:
			if Input.is_action_just_pressed("interact") :
				func_menu(index_menu)
				
		elif tour == 1:
			battle_lock = true
			for ennemi in ennemis_battle :
						if ennemi.pv > 0 :
							turn_time.start()
							var instance_attack = list_attack[1].instantiate()
							add_child(instance_attack)
							instance_attack.battle_menu = self
							await instance_attack.tree_exited
							ennemi.ia_move(player_battle,ennemi_attack_result)
			
			animation.play_backwards("menu_show")
			await animation.animation_finished
			battle_lock = false
			tour = 0
