extends CanvasLayer
@export var game_root = null

@onready var menu = $NinePatchRect/MarginContainer/Label
@onready var bip = $audio/bip
@onready var music = $audio/music
@onready var animation = $AnimationPlayer
@onready var instruction = $ColorRect

@onready var title = $TexCompleteTitle
@onready var label = $Label3
@onready var bg = $background
@onready var bg2 = $background2
@onready var bg_color = $ColorRect
@onready var instru_text = $ColorRect/Label

@onready var rng = $Label4

var instru_read = false
var menu_lock = false

var label_menu = ["new game","load game","option","infos","quit"]

var linestart = [\
"bonjour"]


func func_menu(index):
	if index == 0 :
		bip.playing = false
		game_root.start_game()
	if index == 1 :
		music.playing = false
		bip.playing = false
		game_root.load_game()
	if index == 2 :
		pass
	if index == 3 :
		music.playing = false
		bip.playing = false
		game_root.start_infos()
	if index == 4 :
		get_tree().quit()


var text_select = "<"

var index_menu = 0

func update_menu():
	var text = ""
	for i in range(len(label_menu)) :
		text += is_select(i,"[") + label_menu[i] + is_select(i,"]") + "\n"
	menu.text = text

func _ready():
	setup()

func setup() -> void:
	bg_color.show()
	bg_color.modulate = Color(1,1,1,1)
	instru_text.modulate = Color(1,1,1,0)
	var texture_title = preload("res://title/tex_bob_title.png")
	title.texture = texture_title
	title.scale = Vector2.ZERO
	label.text = ""
	bg.position = Vector2(128,384)
	bg2.position = Vector2(128,256)
	menu_lock = false
	instru_read = false
	music.playing = false
	animation.play("RESET")
	index_menu = 0
	
	
	update_menu()
	animation.play("instruction")
	await animation.animation_finished
	instru_read = true
	animation.play("title")
	#text_play + is_select(0) + "\n" + text_option + is_select(1) + "\n" + text_quit + is_select(2)

func is_select(button_index,str_selec) :
	if button_index == index_menu :
		return str_selec
	else :
		return ""

func _input(event: InputEvent) -> void:
	if instru_read and not menu_lock:
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
		if event.is_action_pressed("interact") :
			bip.play()
			func_menu(index_menu)
	else :
		if Input.is_action_just_pressed("interact") and not instru_read:
			animation.play("instruction_short")

	update_menu()
