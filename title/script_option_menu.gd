extends CanvasLayer

var index_menu = 0
@onready var menu = $NinePatchRect/Label
var index_submenu = -1
@onready var submenu = $NinePatchRect2/Label2

@onready var detail_label = $NinePatchRect3/Label2

@onready var ost = $soundtest_music
@onready var ost_ico = $NinePatchRect4
@onready var animation = $AnimationPlayer

var in_submenu = false

var game_root = null

var menu_name = ["rapide","jeu","vidéo","audio","soundtest","retour"]

var rapide_name = ["difficulter : ","audio global : "]
var game_name = ["3","4"]
var video_name = ["5","6"]
var audio_name = ["7","8"]
var soundtest_name = []
var back_name = []

var info_name = [\
["option rapide",["un","deux"]],
["parametre du jeu",["trois","quatre"]],
["option vidéo",["cinq","six"]],
["option audio",["sept","huit"]],
["permet de tester les musiques",[]],
["revenir au menu principale",[]]]

var submenu_name = [rapide_name,game_name,video_name,audio_name,soundtest_name,back_name]

func _ready() -> void:
	for music in ost.get_children() :
		soundtest_name.append(music.name)
	update_menu()

func update_menu():
	var text = ""
	for i in range(len(menu_name)) :
		text += menu_name[i] + is_select(i,"<") + "\n"
	menu.text = text
	text = menu_name[index_menu] + " :\n \n"
	for i in range(len(submenu_name[index_menu])) :
		text += submenu_name[index_menu][i] + is_select_sub(i,"<") + "\n"
	submenu.text = text

func is_select(button_index,str_selec) :
	if button_index == index_menu :
		return str_selec
	else :
		return ""

func is_select_sub(button_index,str_selec) :
	if button_index == index_submenu :
		return str_selec
	else :
		return ""

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("down"):
		if in_submenu == false :
			index_menu += 1
			if index_menu > len(menu_name)-1 :
				index_menu = len(menu_name)-1
		else :
			index_submenu += 1
			if index_submenu > len(submenu_name[index_menu])-1 :
				index_submenu = len(submenu_name[index_menu])-1
	if event.is_action_pressed("up"):
		if in_submenu == false :
			index_menu -= 1
			if index_menu < 0 :
				index_menu = 0
		else :
			index_submenu -= 1
			if index_submenu < 0 :
				index_submenu = 0
	
	if Input.is_action_just_pressed("interact"):
		if in_submenu == false and len(submenu_name[index_menu]) != 0:
			in_submenu = true
			index_submenu = 0
			
		if index_menu == 4 and in_submenu:
			for music in ost.get_children() :
				music.playing = false
			for ico in ost_ico.get_children() :
				ico.hide()
			ost.get_child(index_submenu).playing = true
			ost_ico.get_child(index_submenu).show()
			
		
		if index_menu == 5 and not in_submenu:
			animation.play("close")
			await animation.animation_finished
			game_root.title.setup()
			game_root.main_menu_pause(false)
			queue_free()
		
	if event.is_action_pressed("run"):
		if in_submenu == true :
			in_submenu = false
			index_submenu = -1
			for music in ost.get_children() :
				music.playing = false
			for ico in ost_ico.get_children() :
				ico.hide()
	
	if in_submenu == false :
		detail_label.text = info_name[index_menu][0]
	else :
		if index_menu != 4 :
			detail_label.text = info_name[index_menu][1][index_submenu]
		else :
			detail_label.text = "les images on été prise en beta 0.10.3"
	update_menu()
	
