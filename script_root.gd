extends Node

@onready var game = $viewport/game_sub_viewport/game
@onready var battle = $viewport/battle
@onready var title = $viewport/main_menu
@onready var textbox = $viewport/text_box
@onready var animation = $animation_game


@export var level_scene: PackedScene
@export var player_scene: PackedScene
@export var battle_scene: PackedScene
@export var shop_scene: PackedScene
@export var text_box: PackedScene
@export var menu_scene: PackedScene
@onready var player = null
@onready var actual_level = null
var actual_level_path = ""
@onready var map_name_label = $game_view/Label

var config = ConfigFile.new()

func _ready():
	title.game_root = self

func load_level(path:String,spawn_index:int):
	var show_msg = true
	
	map_name_label.position = Vector2(0,-8)
	if spawn_index != -1 :
		player.set_process_mode(PROCESS_MODE_DISABLED)
		animation.play("transition_on")
		await animation.animation_finished
	if spawn_index > -2 :
		if actual_level != null :
			actual_level.queue_free()
		var level_load = load(path)
		var level_instance = level_load.instantiate()
		actual_level_path = path
		actual_level = level_instance
		game.add_child(level_instance)
	
	if spawn_index < -1:
		spawn_index = abs(spawn_index+2)
		show_msg = false
	
	var spawn_position = actual_level.get_spawn_by_id(spawn_index)
	player.proba_battle = actual_level.encounter_rate
	actual_level.player = player
	
	if spawn_index != -1 :
		player.position = spawn_position
		player.update_camera()
		animation.play("transition_off")
		await animation.animation_finished
		player.set_process_mode(0)
	
	if show_msg :
		map_name_label.text = actual_level.map_name
		animation.play("welcome")
	

func tp_level(spawn_index:int):
	map_name_label.position = Vector2(0,-8)
	animation.play("transition_on")
	await animation.animation_finished
	var spawn_position = actual_level.get_spawn_by_id(spawn_index)
	player.position = spawn_position
	animation.play("transition_off")
	await animation.animation_finished

func start_game():
	title.set_process_mode(PROCESS_MODE_DISABLED)
	title.hide()
	var player_instance = player_scene.instantiate()
	player_instance.game_root = self
	player = player_instance
	game.add_child(player_instance)
	load_level("res://levels/scn_bobcity_ext_overworld.tscn",1)

func start_text(lines,area):
	player.set_process_mode(PROCESS_MODE_DISABLED)
	var text_instance = text_box.instantiate()
	text_instance.tree_exited.connect(end_text)
	area.animation.play("talk")
	text_instance.tree_exited.connect(area.end_talk)
	text_instance.lines_text_box = lines
	textbox.add_child(text_instance)

func menu():
	player.set_process_mode(PROCESS_MODE_DISABLED)
	var menu_instance = menu_scene.instantiate()
	menu_instance.tree_exited.connect(end_text)
	menu_instance.game_root = self
	menu_instance.player_pv = player.pv
	menu_instance.max_player_pv = player.pv_max
	menu_instance.player_atk = player.atk
	menu_instance.player_dfs = player.def
	menu_instance.player_lvl = player.lvl
	textbox.add_child(menu_instance)
	menu_instance.update_stats()
	
func end_text():
	player.set_process_mode(0)

func start_battle():
	var battle_instance = battle_scene.instantiate()
	battle.add_child(battle_instance)
	battle_instance.game_root = self
	battle_instance.player = player
	battle_instance.player_pv = player.pv
	battle_instance.max_player_pv = player.pv_max
	battle_instance.player_atk = player.atk
	battle_instance.player_dfs = player.def
	game.set_process_mode(PROCESS_MODE_DISABLED)
	player.sprite.frame_coords = Vector2(6,0)
	
func start_shop():
	var shop_instance = shop_scene.instantiate()
	battle.add_child(shop_instance)
	shop_instance.game_root = self
	shop_instance.player = player
	shop_instance.player_pv = player.pv
	shop_instance.max_player_pv = player.pv_max
	shop_instance.player_atk = player.atk
	shop_instance.player_dfs = player.def
	game.set_process_mode(PROCESS_MODE_DISABLED)
	
func end_battle():
	game.set_process_mode(PROCESS_MODE_INHERIT)
	
func save_game():
	print("save test")
	config.set_value("player","position",player.position)
	config.set_value("player","map",actual_level_path)
	config.set_value("player","level",player.lvl)
	config.save("res://bob_simulator.cfg")
	map_name_label.text = "partie sauvegarder"
	animation.play("welcome")

func load_game():
	var save_load = config.load("res://bob_simulator.cfg")
	if save_load == OK :
		if player == null :
			title.set_process_mode(PROCESS_MODE_DISABLED)
			title.hide()
			var player_instance = player_scene.instantiate()
			player_instance.game_root = self
			player = player_instance
			game.add_child(player_instance)
		player.set_process_mode(PROCESS_MODE_DISABLED)
		animation.play("transition_on")
		await animation.animation_finished
		actual_level_path = config.get_value("player","map")
		load_level(actual_level_path,-1)	
		player.position = config.get_value("player","position")
		player.update_camera()
		player.lvl = config.get_value("player","level")
		animation.play("transition_off")
		await animation.animation_finished
		player.set_process_mode(0)
		map_name_label.text = "partie chargé"
		animation.play("welcome")
		
