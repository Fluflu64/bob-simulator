extends Node2D

@onready var animation = $shader_circle/animation_interface
@onready var stats_label = $background/health_border/health_label
@onready var battle_menu = $background/action_border/action_label
@onready var circle = $shader_circle
@onready var label_histo = $background/historic_border/historic_label
@onready var music = $AudioStreamPlayer2D/AudioStreamPlayer


@onready var en_sprite = $background/enemie_sprite
@export var game_root = null
@export var player = null

@export var music_battle = AudioStream

#stats player
var player_pv = 20
var max_player_pv = 20
var player_atk = 2.0
var player_dfs = 2.0

var histo = [\
"bienvenu",
"",
"",
"",
"",
]

var tour = 0
var battle_lock = false

var label_menu = ["buy","talk","item","heal","quit"]
var shop_item = ["item_1","item_2","item_3","item_4","item_5","back"]
var text_to_show = [label_menu,shop_item]
var label_index = 0
var text_select = "<"
var index_menu = 0

func update_player():
	player.pv = player_pv
	player.pv_max = max_player_pv
	player.atk = player_atk
	player.def = player_dfs

func func_menu(index):
	if label_index == 0 :
		if index == 0 :
			battle_lock = true
			animation.play("menu_show")
			await animation.animation_finished
			label_index = 1
			update_menu()
			histo.append("tu veut quoi")
			update_histo()
			animation.play_backwards("menu_show")
			await animation.animation_finished
			battle_lock = false
			

		if index == 1 :
			battle_lock = true
			histo.append("tu es dans une")
			histo.append("pharmacie, tu peut")
			histo.append("acheter des soins")
			histo.append("des boosts et ")
			histo.append("d'autre truc !!")
			update_histo()
			battle_lock = false
			
		
		if index == 2 :
			battle_lock = true
			animation.play("menu_show")
			await animation.animation_finished
			histo.append("tu n'as pas d'objet")
			update_histo()
			animation.play_backwards("menu_show")
			await animation.animation_finished
			battle_lock = false
			
		if index == 3 :
			battle_lock = true
			animation.play("menu_show")
			await animation.animation_finished
			histo.append("tu es heal")
			update_histo()
			player_pv = max_player_pv
			animation.play_backwards("menu_show")
			await animation.animation_finished
			battle_lock = false
		
		if index == 4 :
			battle_lock = true
			histo.append("au revoir")
			update_histo()
			
			animation.play("menu_show")
			await animation.animation_finished
			
			animation.play("battle end")
			await animation.animation_finished
			update_player()
			game_root.end_battle()
			queue_free()
			update_histo()
	if label_index == 1 :
		if index == len(text_to_show[label_index])-1 :
			label_index = 0
			index = 0


func _ready() -> void:
	circle.show()
	animation.play("battle start")
	index_menu = 0
	update_histo()
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
	
	var j = index_menu-4
	if j < 0 :
		j = 0
	for i in range(5) :
		text += text_to_show[label_index][i+j] + is_select(i+j) + "\n"
	battle_menu.text = text

func _input(event: InputEvent) -> void:
	if not battle_lock :
		if event.is_action_pressed("down") :
			index_menu += 1
		if event.is_action_pressed("up") :
			index_menu -= 1
		if index_menu < 0 :
			index_menu = 0
		if index_menu > len(text_to_show[label_index])-1 :
			index_menu = len(text_to_show[label_index])-1
		if event.is_action_pressed("left") :
			pass
		update_menu()
	update_histo()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	stats_label.text = "bob : pv "+str(player_pv)+"/"+ str(max_player_pv)
	
	if not battle_lock :	
		if tour == 0:
			if Input.is_action_just_pressed("interact") :
				func_menu(index_menu)
				
		elif tour == 1:
			battle_lock = true
			
			animation.play_backwards("menu_show")
			await animation.animation_finished
			
			battle_lock = false
			tour = 0
