extends Node2D

@onready var animation = $shader_circle/animation_interface
@onready var battle_anime = $animation_battle
@onready var stats_label = $background/health_border/health_label
@onready var battle_menu = $background/action_border/action_label
@onready var circle = $shader_circle
@onready var label_histo = $background/historic_border/historic_label
@onready var music = $AudioStreamPlayer2D/AudioStreamPlayer

@onready var marker = $background/attack_border/Node2D
var marker_position = Vector2(0,0)
var marker_speed = 0.1
var marker_radius = 32
var player_has_atk = false

@onready var en_sprite = $background/enemie_sprite
@export var game_root = null
@export var player = null

@export var music_battle = AudioStream

#stats player
var player_pv = 20
var max_player_pv = 20
var player_atk = 2.0
var player_dfs = 2.0

#stats ennemi
var ennemi_name = "radouteu"
var ennemei_pv = 10
var max_ennemie_pv = 10
var ennemi_atk = 2.0
var ennemi_dfs = 1.0

var histo = [\
"test",
"kayou",
"",
"",
"",
]

var tour = 0
var battle_lock = false

var label_menu = ["attack","action","item","flee"]
var text_select = "<"
var index_menu = 0

func update_player():
	player.pv = player_pv
	player.pv_max = max_player_pv
	player.atk = player_atk
	player.def = player_dfs

func func_menu(index):
	if index == 0 :
		battle_lock = true
		marker_radius = 32
		animation.play("menu_show")
		await animation.animation_finished
		index_menu = 9
		player_has_atk = true
		
		
		
		
	if index == 1 :
		pass
	
	if index == 2 :
		histo.append("tu n'as pas d'objet")
		update_histo()
	
	if index == 3 :
		battle_lock = true
		histo.append("bob fuit")
		update_histo()
		
		animation.play("menu_show")
		await animation.animation_finished
		if randi_range(0,3)==2:
			
			
			battle_anime.play("player_flee_win")
			await battle_anime.animation_finished
			
			animation.play("battle end")
			await animation.animation_finished
			update_player()
			game_root.end_battle()
			queue_free()
		else :
			
			battle_anime.play("player_flee_lose")
			await battle_anime.animation_finished
			
			histo.append("ça à échouer")
		
			battle_lock = false
			tour = 1
		update_histo()

func _ready() -> void:
	circle.show()
	animation.play("battle start")
	index_menu = 0
	
	update_menu()
	

func is_select(button_index) :
	if button_index == index_menu :
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
		text += label_menu[i] + is_select(i) + "\n"
	battle_menu.text = text

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
		if event.is_action_pressed("left") :
			pass
		update_menu()
	update_histo()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player_has_atk :
		marker_position += Vector2(marker_speed,marker_speed)
		marker.position = Vector2(cos(marker_position.x)*marker_radius+40,sin(marker_position.y)*marker_radius+40)
		marker_radius -= marker_speed
		if marker_radius < 0 :
			marker_radius = 0
	stats_label.text = "bob : pv "+str(player_pv)+"/"+ str(max_player_pv) +" \ncarte man : pv " + str(ennemei_pv)+"/"+ str(max_ennemie_pv)
	if index_menu == 9 :
		if Input.is_action_just_pressed("interact") :
			player_has_atk = false
			index_menu = 0
		
			battle_anime.play("player_atk")
			await battle_anime.animation_finished
			
			var attack = ceil(player_atk / ennemi_dfs)
			ennemei_pv -= attack
			histo.append("bob atk " + str(attack))
			update_histo()
			
			battle_anime.play("ennemi_hit")
			await battle_anime.animation_finished
			
			battle_lock = false
			tour = 1
	
	if not battle_lock :
		if ennemei_pv <= 0 or player_pv <= 0:
				battle_lock = true
				
				if player_pv <= 0 :
					battle_anime.play("player_down")
					await battle_anime.animation_finished
				else :
					battle_anime.play("player_win")
					await battle_anime.animation_finished
				
				animation.play("battle end")
				await animation.animation_finished
				
				update_player()
				
				game_root.end_battle()
				queue_free()
				
		elif tour == 0:
			if Input.is_action_just_pressed("interact") :
				func_menu(index_menu)
				
		elif tour == 1:
			battle_lock = true
			
			battle_anime.play("ennemi_atk")
			await battle_anime.animation_finished
			
			var attack = ceil(ennemi_atk / player_dfs)
			player_pv -= attack
			histo.append(str(ennemi_name) + " atk " + str(attack))
			update_histo()
			
			battle_anime.play("player_hit")
			await battle_anime.animation_finished
			
			animation.play_backwards("menu_show")
			await animation.animation_finished
			
			battle_lock = false
			tour = 0
