class_name Interactable
extends Area2D

@export var lines:Array[String] = ["oui","oui"]
@export var sprite_hide:bool = true
@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D
var instru_check = false

@export var extra_sound:Array[AudioStreamPlayer]


func _ready():
	if sprite_hide :
		sprite.hide()

func end_talk():
	animation.play("stop")

func is_text(game_root,index):
	var code = lines[index]
	var index_line_str = ""
	for i in range(len("txt["),len(code)-1) :
		index_line_str += code[i]
	
	var index_line = int(index_line_str)
	game_root.start_text([BobGlobal.langue[BobGlobal.langindex][index_line]],self)

func is_bip(game_root,index):
	var code = lines[index]
	var index_line_str = ""
	for i in range(len("bip["),len(code)-1) :
		index_line_str += code[i]
	
	var index_line = int(index_line_str)
	game_root.bip_index = index_line

func is_test(game_root):
	game_root.start_text(["test"],self)

func is_snd(_game_root,index):
	var code = lines[index]
	var index_line_str = ""
	for i in range(len("snd["),len(code)-1) :
		index_line_str += code[i]
	var index_line = int(index_line_str)
	var node_affect = extra_sound[index_line]
	node_affect.playing = true

func interact(game_root):
	game_root.bip_index = 0
	for line in range(len(lines)) :
		if lines[line].contains("txt[") and lines[line].contains("]") :
			is_text(game_root,line)
			instru_check = true
			await game_root.dialogue_end
		
		elif lines[line].contains("test[") and lines[line].contains("]") :
			is_test(game_root)
			instru_check = true
			await game_root.dialogue_end
		
		elif lines[line].contains("bip[") and lines[line].contains("]") :
			is_bip(game_root,line)
			instru_check = true
		
		elif lines[line].contains("snd[") and lines[line].contains("]") :
			is_snd(game_root,line)
			instru_check = true
		
	if not instru_check :
		game_root.start_text(["c'est pas encore fait"],self)
