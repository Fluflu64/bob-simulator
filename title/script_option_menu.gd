extends CanvasLayer

var index_menu = 0
@onready var menu = $NinePatchRect/Label
var index_submenu = -1
@onready var submenu = $NinePatchRect2/Label2

var menu_block = true

@onready var ost = $soundtest_music
@onready var ost_ico = $NinePatchRect4
@onready var animation = $AnimationPlayer

var volumes = [100,75,50,25,0]
var volume_index = 0

var in_submenu = false

var game_root = null

var menu_name = ["jeu","langue","vidéo","audio","soundtest","retour"]

var rapide_name = [BobGlobal.langue[BobGlobal.langindex][89],BobGlobal.langue[BobGlobal.langindex][90],BobGlobal.langue[BobGlobal.langindex][91]]
var game_name = ["français","english"]
var video_name = ["5","6"]
var audio_name = [BobGlobal.langue[BobGlobal.langindex][330] + ": "+ str(volumes[volume_index]) + "%"]
var soundtest_name = []
var back_name = []

@onready var music_ico = $NinePatchRect4/reset
@onready var music_stream = $soundtest_music/reset
var music_dico = {\
"Reset" : [null,null],
"Ambush" : [preload("res://music/icone/tex_battle_2.png"),preload("res://music/battle_theme.ogg")],
"Bob is a dark city" : [preload("res://music/icone/tex_dark_city.png"),preload("res://music/mus_dark_city.wav")],
"Fly or cry" : [preload("res://music/icone/tex_fly.png"),preload("res://music/fly or cry.ogg")],
"Its me the radouteu" : [preload("res://music/icone/tex_music_battle.png"),preload("res://music/battle_test2.ogg")],
"A nightmare dream" : [preload("res://music/icone/tex_music_castle.png"),preload("res://music/mus_castle.ogg")],
"city" : [preload("res://music/icone/tex_music_city.png"),preload("res://music/mus_city.ogg")],
"house" : [preload("res://music/icone/tex_music_house.png"),preload("res://music/mus_house.ogg")],
"overworld" : [preload("res://music/icone/tex_music_overworld.png"),preload("res://music/overworld.wav")],
"Why the worlc so rude" : [preload("res://music/icone/tex_music_sad.png"),preload("res://music/mus_sad_song.ogg")],
"Its free if you paid 100 gold" : [preload("res://music/icone/tex_music_shop.png"),preload("res://music/mus_shop.ogg")],
"Welcome to Bobland story" : [preload("res://music/icone/tex_music_title.png"),preload("res://music/mus_title.ogg")],
"Wasted bob" : [preload("res://music/icone/tex_music_underworld.png"),preload("res://music/castle.ogg")],
"bob around" : [preload("res://music/icone/tex_bobaround.png"),preload("res://music/bobaround.wav")],
"Wlcm to Boblnd stry" : [preload("res://music/icone/tex_music_title_og.png"),preload("res://music/mus_title_og.ogg")],
"Bob win(string)" : [preload("res://music/icone/tex_music_version_0.png"),preload("res://music/version 0.wav")],
"Bob win(wind)" : [preload("res://music/icone/tex_music_version_1.png"),preload("res://music/version 1.wav")],
"Bob win(string + wind)" : [preload("res://music/icone/tex_music_version_01.png"),preload("res://music/version 0+1.wav")],
"Bob win" : [preload("res://music/icone/tex_music_version_final.png"),preload("res://music/mus_version final.wav")],
"cave" : [preload("res://music/icone/tex_music_cave.png"),preload("res://music/pololompololom pompompololommm.wav")],
"mega_singe_de_lamortkiuetou" : [preload("res://music/icone/tex_music_singe.png"),preload("res://music/singe.ogg")],
"YES : story mode" : [preload("res://music/icone/tex_music_yes.png"),preload("res://Bob_simulator/mini_game/mini_yes/musique_des_gens_qui_crie.wav")],
"Lever Guy" : [preload("res://music/icone/tex_music_lever_guy.png"),preload("res://music/underground.wav")],
"get a key (LG)" : [preload("res://music/icone/tex_music_lg_key.png"),preload("res://music/key.wav")],
"get a map (LG)" : [preload("res://music/icone/tex_music_lg_map.png"),preload("res://music/got map.wav")],
"dungeon (LG)" : [preload("res://music/icone/tex_music_lg_dungeon.png"),preload("res://music/dungeon.wav")],
"End origine" : [preload("res://music/icone/tex_music_end_origine.png"),preload("res://music/black hole.wav")],
"Parachneloba" : [preload("res://music/icone/tex_music_lever_guy_para.png"),preload("res://music/parachneloba.wav")],
"Ending (LG)" : [preload("res://music/icone/tex_music_lg_end.png"),preload("res://music/ending.wav")]
}



var submenu_name = [rapide_name,game_name,video_name,audio_name,soundtest_name,back_name]

func reload_menu():
	menu_name = []
	for button in range(6) :
		menu_name.append(BobGlobal.langue[BobGlobal.langindex][58+button])
	
	soundtest_name = []
	for music in music_dico :
		soundtest_name.append(music)
	
	submenu_name = [rapide_name,game_name,video_name,audio_name,soundtest_name,back_name]
	update_menu()

func _ready() -> void:
	reload_menu()
	animation.play("open")
	await animation.animation_finished
	menu_block = false

func update_menu():
	var text = ""
	for i in range(len(menu_name)) :
		text += menu_name[i] + is_select(i,"<") + "\n"
	menu.text = text
	text = menu_name[index_menu] + " :\n \n"
	var start = int(index_submenu/8.0) *8
	var len_menu = 8 +start
	if len_menu >  len(submenu_name[index_menu]) :
		len_menu =  len(submenu_name[index_menu])
	for i in range(start,len_menu) :
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
	if not menu_block :
		if Input.is_action_just_pressed("down"):
			if in_submenu == false :
				index_menu += 1
				if index_menu > len(menu_name)-1 :
					index_menu = len(menu_name)-1
			else :
				index_submenu += 1
				if index_submenu > len(submenu_name[index_menu])-1 :
					index_submenu = len(submenu_name[index_menu])-1
		if Input.is_action_just_pressed("up"):
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
				if index_menu == 1 :
					index_submenu = BobGlobal.langindex
				else :
					index_submenu = 0
				
			if index_menu == 3 and index_submenu:
				var audio_name = [BobGlobal.langue[BobGlobal.langindex][330] + ": "+ str(volumes[volume_index]) + "%"]
				submenu_name = [rapide_name,game_name,video_name,audio_name,soundtest_name,back_name]
			
			if index_menu == 4 and in_submenu:

				music_ico.show()
				music_ico.texture = music_dico[soundtest_name[index_submenu]][0]
				music_stream.stream = music_dico[soundtest_name[index_submenu]][1]
				music_stream.playing = true
				#for music in ost.get_children() :
				#	music.playing = false
				#for ico in ost_ico.get_children() :
				#	ico.hide()
				#ost.get_child(index_submenu).playing = true
				#ost_ico.get_child(index_submenu).show()
				
			
			if index_menu == 5 and not in_submenu:
				animation.play("close")
				await animation.animation_finished
				game_root.title.setup()
				game_root.main_menu_pause(false)
				queue_free()
			
			if index_menu == 1 and in_submenu:
				BobGlobal.langindex = index_submenu
				reload_menu()
				game_root.save_param()
			
		if event.is_action_pressed("run"):
			if in_submenu == true :
				in_submenu = false
				index_submenu = -1
				for music in ost.get_children() :
					music.playing = false
				for ico in ost_ico.get_children() :
					ico.hide()
		
		update_menu()
