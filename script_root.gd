extends Node

var save_name = "bob.save"
var save_path = "res://" + save_name

var alter_loading_og = preload("res://tex_load_ico_alter000.png")
var alter_loading = preload("res://tex_load_ico_alter001.png")
var alter_loading_pet = preload("res://tex_load_ico_alter002.png")
var alter_loading_b3313 = preload("res://tex_load_ico_alter003.png")
var alter_loading_chara = preload("res://tex_load_ico_alter004.png")
@onready var sprite_loading_screen = $game_view/ColorRect/Sprite2D

@onready var game = $viewport/game_sub_viewport/game
@onready var battle = $viewport/battle
@onready var title = $viewport/main_menu
@onready var textbox = $viewport/text_box
@onready var animation = $animation_game

signal dialogue_end
signal battle_end

@export var level_scene: PackedScene
@export var player_scene: PackedScene
@export var battle_scene: PackedScene
@export var shop_scene: PackedScene
@export var text_box: PackedScene
@export var menu_scene: PackedScene
@export var menu_infos_scene: PackedScene
@export var choice_menu : PackedScene
@onready var player = null
@onready var actual_level = null
var actual_level_path = ""
@onready var map_name_label = $game_view/Label
var battle_music = null
var config = ConfigFile.new()

var bip_index = 0

var why = 0

func main_menu_pause(pause):
	if pause :
		title.hide()
		title.set_process_mode(PROCESS_MODE_DISABLED)
	else :
		title.show()
		title.set_process_mode(PROCESS_MODE_INHERIT)

func open_submenu(submenu):
	var submenu_inst = submenu.instantiate()
	submenu_inst.game_root = self
	textbox.add_child(submenu_inst)

func _ready():
	load_param()
	sprite_loading_screen.hide()
	title.game_root = self
	BobGlobal.game_root = self
	load_why()
	var rng_to_show = str(why)
	if why < 100 :
		rng_to_show = "0" + rng_to_show
		if why < 10 :
			rng_to_show = "0" + rng_to_show
	title.rng.text = rng_to_show
	if why == 1 :
		sprite_loading_screen.texture = alter_loading_og
		title.sprite_loading_screen.texture = alter_loading_og
	
	if why == 99 :
		sprite_loading_screen.texture = alter_loading_chara
		title.sprite_loading_screen.texture = alter_loading_chara
	
	if why == 08 or why == 80 or why == 88 :
		sprite_loading_screen.texture = alter_loading
		title.sprite_loading_screen.texture = alter_loading
	
	if why == 33 or why == 13 :
		sprite_loading_screen.texture = alter_loading_b3313
		title.sprite_loading_screen.texture = alter_loading_b3313
	
	if why == 17 :
		sprite_loading_screen.texture = alter_loading_pet
		title.sprite_loading_screen.texture = alter_loading_pet

func load_level(path:String,spawn_name:String,transition:int = 0):
	var show_msg = false
	map_name_label.position = Vector2(0,-8)
	
	if transition == 0 or transition == 2 :
		player.set_process_mode(PROCESS_MODE_DISABLED)
		animation.play("transition_on")
		await animation.animation_finished
	
	if path != "-1":
		if actual_level != null :
			actual_level.queue_free()
		show_msg = true
		var level_load = load(path)
		var level_instance = level_load.instantiate()
		level_instance.root = self
		level_instance.player = player
		level_instance.test()
		actual_level_path = path
		actual_level = level_instance
		game.add_child(level_instance)
	
	if spawn_name != "-1" :
		var spawn_position = actual_level.get_spawn_by_id(spawn_name)
		
		player.position = spawn_position + Vector2(0,-1)
		#player.update_camera()
		map_name_label.text = actual_level.map_name
		player.set_process_mode(0)
		if transition == 0 or transition == 1:
			animation.play("transition_off")
			await animation.animation_finished
		
	battle_music = actual_level.battle_theme
	player.proba_battle = actual_level.encounter_rate
	actual_level.player = player
	
	if show_msg :
		animation.play("welcome")

func start_game():
	title.animation.play("intro")
	title.menu_lock = true
	await title.animation.animation_finished
	title.setup()
	title.set_process_mode(PROCESS_MODE_DISABLED)
	title.hide()
	var player_instance = player_scene.instantiate()
	player_instance.game_root = self
	player = player_instance
	game.add_child(player_instance)
	load_level("res://levels/scn_bobcity_int.tscn","game start",3)

func start_infos():
	title.animation.play("load")
	await title.animation.animation_finished
	animation.play("transition_on")
	await animation.animation_finished
	title.setup()
	title.set_process_mode(PROCESS_MODE_DISABLED)
	title.hide()
	var player_instance = player_scene.instantiate()
	player_instance.game_root = self
	player = player_instance
	player.infos_mode = true
	game.add_child(player_instance)
	load_level("res://levels/scn_infos_map.tscn","spawn_base",3)
	animation.play("transition_off")
	await animation.animation_finished

func end_game():
	title.set_process_mode(PROCESS_MODE_INHERIT)
	title.setup()
	title.show()
	for elem in game.get_children():
		elem.queue_free()
	for elem in textbox.get_children():
		elem.queue_free()
	
	for elem in battle.get_children():
		elem.queue_free()

func start_text(lines,area):
	player.set_process_mode(PROCESS_MODE_DISABLED)
	var text_instance = text_box.instantiate()
	text_instance.tree_exited.connect(end_text)
	if area :
		area.animation.play("talk")
		text_instance.tree_exited.connect(area.end_talk)
	text_instance.lines_text_box = lines
	textbox.add_child(text_instance)
	text_instance.set_bip(bip_index)

func start_choice(lines,_area): #choice_menu
	player.set_process_mode(PROCESS_MODE_DISABLED)
	var text_instance = choice_menu.instantiate()
	text_instance.lines_text_box = lines
	textbox.add_child(text_instance)

func menu():
	game.set_process_mode(PROCESS_MODE_DISABLED)
	var menu_instance = menu_scene.instantiate()
	menu_instance.tree_exited.connect(end_pause)
	menu_instance.game_root = self
	menu_instance.player_pv = player.pv
	menu_instance.max_player_pv = player.pv_max
	menu_instance.player_atk = player.atk
	menu_instance.player_dfs = player.def
	menu_instance.player_lvl = player.lvl
	textbox.add_child(menu_instance)
	menu_instance.update_stats()

func menu_infos():
	game.set_process_mode(PROCESS_MODE_DISABLED)
	var menu_instance = menu_infos_scene.instantiate()
	menu_instance.tree_exited.connect(end_pause)
	menu_instance.game_root = self
	textbox.add_child(menu_instance)

func end_text():
	player.set_process_mode(PROCESS_MODE_INHERIT)
	dialogue_end.emit()

func end_choice(choice_box):
	print(choice_box)

func end_pause():
	game.set_process_mode(PROCESS_MODE_INHERIT)

func start_battle():
	var battle_instance = battle_scene.instantiate()
	
	battle.add_child(battle_instance)
	battle_instance.music.stream = actual_level.battle_theme
	battle_instance.battle_area.self_modulate = actual_level.battle_color
	battle_instance.music.playing = true
	#battle_instance.tree_exited.connect(end_battle)
	battle_instance.game_root = self
	battle_instance.player = player
	battle_instance.player_pv = player.pv
	battle_instance.max_player_pv = player.pv_max
	battle_instance.player_atk = player.atk
	battle_instance.player_dfs = player.def
	
	battle_instance.player_battle.nom = "Bob"
	
	battle_instance.player_battle.pv = battle_instance.player_pv
	battle_instance.player_battle.max_pv = battle_instance.max_player_pv
	
	battle_instance.player_battle.base_atk = battle_instance.player_atk
	
	battle_instance.player_battle.atk = battle_instance.player_battle.base_atk
	
	battle_instance.player_battle.base_dfs = battle_instance.player_dfs
	battle_instance.player_battle.dfs = battle_instance.player_battle.base_dfs
	
	game.set_process_mode(PROCESS_MODE_DISABLED)
	player.sprite.frame_coords = Vector2(6,0)

func start_shop(spawn_name:String):
	map_name_label.position = Vector2(0,-8)
	animation.play("transition_on")
	await animation.animation_finished
	
	var shop_instance = shop_scene.instantiate()
	battle.add_child(shop_instance)
	var spawn_position = actual_level.get_spawn_by_id(spawn_name)
	player.position = spawn_position
	shop_instance.game_root = self
	shop_instance.player = player
	shop_instance.player_pv = player.pv
	shop_instance.max_player_pv = player.pv_max
	shop_instance.player_atk = player.atk
	shop_instance.player_dfs = player.def
	
	animation.play("transition_off")
	await animation.animation_finished
	
	game.set_process_mode(PROCESS_MODE_DISABLED)

func start_mini_game(path):
	map_name_label.position = Vector2(0,-8)
	animation.play("transition_on")
	await animation.animation_finished
	var preload_game = load(path)
	var shop_instance = preload_game.instantiate()
	battle.add_child(shop_instance)
	shop_instance.game_root = self
	animation.play("transition_off")
	await animation.animation_finished
	
	game.set_process_mode(PROCESS_MODE_DISABLED)

func end_battle():
	game.set_process_mode(PROCESS_MODE_INHERIT)
	battle_end.emit()

func save_game():
	print("save test")
	config.set_value("player","position",player.position)
	config.set_value("player","map",actual_level_path)
	config.set_value("player","level",player.lvl)
	config.set_value("player","story",player.story)
	config.save(save_path)
	map_name_label.text = "partie sauvegarder"
	animation.play("welcome")

func load_game():
	var save_load = config.load(save_path)
	title.menu_lock = true
	if save_load == OK :
		if player == null :
			var player_instance = player_scene.instantiate()
			player_instance.game_root = self
			player = player_instance
			game.add_child(player_instance)
		player.set_process_mode(PROCESS_MODE_DISABLED)
		if title.visible :
			title.animation.play("load")
			await title.animation.animation_finished
		animation.play("transition_on")
		await animation.animation_finished
		
		title.setup()
		title.set_process_mode(PROCESS_MODE_DISABLED)
		title.hide()
		actual_level_path = config.get_value("player","map")
		player.position = config.get_value("player","position")
		player.lvl = config.get_value("player","level")
		player.story = config.get_value("player","story")
		load_level(actual_level_path,"-1",3)
		player.set_process_mode(0)
		animation.play("transition_off")
		await animation.animation_finished
		player.frame_direction = 0
		player.animation.play("idle")
		player.sprite.frame_coords = Vector2(0,0)
		map_name_label.text = "partie chargé"
		animation.play("welcome")

func load_why():
	
	var why_load = config.load(save_path)
	if why_load != null :
		if config.get_value("why","why") != OK :
			why = config.get_value("why","why")
		else :
			why = randi_range(1,100)
			config.set_value("why","why",why)
			config.save(save_path)
	else :
		why = randi_range(1,100)
		config.set_value("why","why",why)
		config.save(save_path)

func load_param():
	var _param_load = config.load(save_path)
	if config.get_value("option","lang") == OK :
		BobGlobal.langindex = config.get_value("option","lang")
	title.setup()
	
	if BobGlobal.langindex != config.get_value("option","lang") :
		config.set_value("option","lang",BobGlobal.langindex)
		config.save(save_path)

func save_param():
	var _param_load = config.load(save_path)
	config.set_value("option","lang",BobGlobal.langindex)
	config.save(save_path)
