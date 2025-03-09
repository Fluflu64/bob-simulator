extends CanvasLayer
@export var game_root = null

@onready var menu = $Label
@onready var bip = $audio/bip
@onready var animation = $AnimationPlayer

var label_menu = ["play","option","infos","quit"]


func func_menu(index):
	if index == 0 :
		game_root.start_game()
	if index == 1 :
		pass
	if index == 2 :
		pass
	if index == 3 :
		get_tree().quit()


var text_select = "<"

var index_menu = 0

func update_menu():
	var text = ""
	for i in range(len(label_menu)) :
		text += label_menu[i] + is_select(i) + "\n"
	menu.text = text

func _ready() -> void:
	update_menu()
	animation.play("title")
	#text_play + is_select(0) + "\n" + text_option + is_select(1) + "\n" + text_quit + is_select(2)

func is_select(button_index) :
	if button_index == index_menu :
		return text_select
	else :
		return ""

func _input(event: InputEvent) -> void:
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
	if event.is_action_pressed("ui_accept") :
		bip.play()
		func_menu(index_menu)
	update_menu()
