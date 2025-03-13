extends CanvasLayer



@onready var stats_label = $stats_border/stats_label
@onready var menu_label = $option_border/option_label

@export var game_root = null
@export var player = null

#stats player
var player_pv = 20
var max_player_pv = 20
var player_atk = 2.0
var player_dfs = 2.0

var label_menu = ["item","option","save game","load game"]
var text_select = "<"
var index_menu = 0

func func_menu(index):
	if index == 0 :
		pass
	
	if index == 1 :
		pass
	
	if index == 2 :
		game_root.save_game()
		queue_free()
	
	if index == 3 :
		game_root.load_game()
		queue_free()

func _ready() -> void:
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
	"Bob lvl 50 9999G \npv : "+ str(player_pv) +"/"+ str(max_player_pv) +"\natk : "+ str(player_atk) +" def : "+ str(player_dfs) 

func update_menu():
	var text = ""
	for i in range(len(label_menu)) :
		text += label_menu[i] + is_select(i) + "\n"
	menu_label.text = text

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("run"):
		queue_free()
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
	if event.is_action_pressed("interact"):
		func_menu(index_menu)
	update_menu()
