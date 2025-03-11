extends Node

@onready var game = $viewport/game_sub_viewport/game
@onready var battle = $viewport/battle
@onready var title = $viewport/main_menu
@onready var textbox = $viewport/text_box


@export var level_scene: PackedScene
@export var player_scene: PackedScene
@export var battle_scene: PackedScene
@export var text_box: PackedScene
@export var menu_scene: PackedScene
@onready var player = null
@onready var actual_level = null

func _ready():
	title.game_root = self

func load_level(path:String,spawn_index:int):
	if actual_level != null :
		actual_level.queue_free()
	var level_load = load(path)
	var level_instance = level_load.instantiate()
	actual_level = level_instance
	game.add_child(level_instance)
	var spawn_position = actual_level.get_spawn_by_id(spawn_index)
	player.position = spawn_position
	player.proba_battle = actual_level.encounter_rate
	

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
	menu_instance.player_pv = player.pv
	menu_instance.max_player_pv = player.pv_max
	menu_instance.player_atk = player.atk
	menu_instance.player_dfs = player.def
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
	
func end_battle():
	game.set_process_mode(PROCESS_MODE_INHERIT)
