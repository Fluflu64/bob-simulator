extends CanvasLayer



@onready var stats_label = $stats_border/stats_label
@onready var menu_label = $option_border/option_label
@onready var animation = $AnimationPlayer
@onready var bip = $audio/bip

@export var game_root = null
@export var player = null

#stats player
var player_pv = 20
var max_player_pv = 20
var player_atk = 2.0
var player_dfs = 2.0
var player_lvl = 1
var label_menu = ["item","save","load","menu","quit"]
var text_select = "<"
var index_menu = 0

func func_menu(index):
	if index == 0 :
		pass
	
	if index == 1 :
		animation.play("close")
		await animation.animation_finished
		game_root.save_game()
		queue_free()
	
	if index == 2 :
		animation.play("close")
		await animation.animation_finished
		game_root.load_game()
		queue_free()
	
	if index == 3 :
		animation.play("bye bye")
		await animation.animation_finished
		game_root.end_game()
	
	if index == 4 :
		get_tree().quit()

func _ready() -> void:
	animation.play("open")
	index_menu = 0
	update_menu()
	update_stats()
	

func is_select(button_index) :
	if button_index == index_menu :
		return text_select
	else :
		return ""

func update_stats():
	stats_label.text = \
	"Bob's lop "+str(player_lvl)+" 0 BG \npv : "+ str(player_pv) +"/"+ str(max_player_pv) +"\natk : "+ str(player_atk) +" def : "+ str(player_dfs) 

func update_menu():
	var text = ""
	for i in range(len(label_menu)) :
		text += label_menu[i] + is_select(i) + "\n"
	menu_label.text = text

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("run"):
		animation.play("close")
		await animation.animation_finished
		queue_free()
	if event.is_action_pressed("down") :
		index_menu += 1
		bip.play()
	if event.is_action_pressed("up") :
		index_menu -= 1
		bip.play()
	if index_menu < 0 :
		index_menu = 0
	if index_menu > len(label_menu)-1 :
		index_menu = len(label_menu)-1
	if event.is_action_pressed("left") :
		pass
	if event.is_action_pressed("interact"):
		func_menu(index_menu)
	update_menu()
