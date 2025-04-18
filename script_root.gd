extends Node

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
@onready var player = null
@onready var actual_level = null
var actual_level_path = ""
@onready var map_name_label = $game_view/Label

var config = ConfigFile.new()

var why = 0

func _ready():
	title.game_root = self
	load_why()
	var rng_to_show = str(why)
	if why < 100 :
		rng_to_show = "0" + rng_to_show
		if why < 10 :
			rng_to_show = "0" + rng_to_show
	title.rng.text = rng_to_show

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
		player.update_camera()
		map_name_label.text = actual_level.map_name
		if transition == 0 or transition == 1:
			animation.play("transition_off")
			await animation.animation_finished
		player.set_process_mode(0)
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
	title.setup()
	title.set_process_mode(PROCESS_MODE_DISABLED)
	title.hide()
	var player_instance = player_scene.instantiate()
	player_instance.game_root = self
	player = player_instance
	player.infos_mode = true
	game.add_child(player_instance)
	load_level("res://levels/scn_infos_map.tscn","spawn_base",3)

func end_game():
	title.set_process_mode(PROCESS_MODE_INHERIT)
	title.setup()
	title.show()
	
	for elem in textbox.get_children():
		elem.queue_free()
	for elem in game.get_children():
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

func end_pause():
	game.set_process_mode(PROCESS_MODE_INHERIT)

func start_battle():
	var battle_instance = battle_scene.instantiate()
	battle.add_child(battle_instance)
	#battle_instance.tree_exited.connect(end_battle)
	battle_instance.game_root = self
	battle_instance.player = player
	battle_instance.player_pv = player.pv
	battle_instance.max_player_pv = player.pv_max
	battle_instance.player_atk = player.atk
	battle_instance.player_dfs = player.def
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

func end_battle():
	game.set_process_mode(PROCESS_MODE_INHERIT)
	battle_end.emit()

func save_game():
	print("save test")
	config.set_value("player","position",player.position)
	config.set_value("player","map",actual_level_path)
	config.set_value("player","level",player.lvl)
	config.set_value("player","story",player.story)
	config.save("res://bob_simulator.cfg")
	map_name_label.text = "partie sauvegarder"
	animation.play("welcome")

func load_game():
	var save_load = config.load("res://bob_simulator.cfg")
	if save_load == OK :
		if player == null :
			title.setup()
			title.set_process_mode(PROCESS_MODE_DISABLED)
			title.hide()
			var player_instance = player_scene.instantiate()
			player_instance.game_root = self
			player = player_instance
			game.add_child(player_instance)
		player.set_process_mode(PROCESS_MODE_DISABLED)
		#animation.play("transition_on")
		#await animation.animation_finished
		actual_level_path = config.get_value("player","map")
		player.position = config.get_value("player","position")
		player.update_camera()
		player.lvl = config.get_value("player","level")
		player.story = config.get_value("player","story")
		load_level(actual_level_path,"-1",3)
		#animation.play("transition_off")
		#await animation.animation_finished
		player.frame_direction = 0
		player.animation.play("idle")
		player.sprite.frame_coords = Vector2(0,0)
		player.set_process_mode(0)
		map_name_label.text = "partie chargé"
		animation.play("welcome")

func load_why():
	var why_load = config.load("res://bob_simulator.cfg")
	if why_load == OK :
		if config.get_value("why","why") :
			why = config.get_value("why","why")
		else :
			why = randi_range(0,100)
			config.set_value("why","why",why)
			config.save("res://bob_simulator.cfg")
	else :
		why = randi_range(0,100)
		config.set_value("why","why",why)
		config.save("res://bob_simulator.cfg")
