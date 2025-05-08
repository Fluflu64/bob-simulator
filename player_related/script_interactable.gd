class_name Interactable
extends Area2D

@export var when_active:Array[Vector2]
var finaly_is_was_active = true
@export var setup_lines:Array[String]
@export var lines:Array[String] = ["oui","oui"]
@export var sprite_hide:bool = true
@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D
var instru_check = false

@export var automatic = false

@export var interact_disable = false

@export var extra_sound:Array[AudioStreamPlayer]
@export var sub_cam:Camera2D
@export var pnj:Node
var use_sub_cam = false
var player_cam = null
@export var animation_player:AnimationPlayer

func _ready():
	for trigger in when_active :
		if trigger.x <= BobGlobal.game_root.player.story :
			if trigger.y == 0 :
				finaly_is_was_active = false
			else :
				finaly_is_was_active = true
	
	if finaly_is_was_active :
		if len(setup_lines) > 0 :
			execute_lines(BobGlobal.game_root,setup_lines)
	if automatic :
		set_collision_layer_value(1,true)
		set_collision_mask_value(1,true)
	if sprite_hide :
		sprite.hide()

func _process(_delta):
	if use_sub_cam :
		player_cam.global_position = sub_cam.position + Vector2(-8,0)

func end_talk():
	animation.play("stop")

func is_text(game_root,index,codes):
	var code = codes[index]
	var index_line_str = ""
	for i in range(len("txt["),len(code)-1) :
		index_line_str += code[i]
	
	var index_line = int(index_line_str)
	game_root.start_text([BobGlobal.langue[BobGlobal.langindex][index_line]],self)

func is_func(game_root,index,codes):
	var code = codes[index]
	var index_line_str = ""
	for i in range(len("func["),len(code)-1) :
		index_line_str += code[i]
	
	var index_line = int(index_line_str)
	pnj.function(game_root,index_line)

func is_bip(game_root,index,codes):
	var code = codes[index]
	var index_line_str = ""
	for i in range(len("bip["),len(code)-1) :
		index_line_str += code[i]
	
	var index_line = int(index_line_str)
	game_root.bip_index = index_line

func is_test(game_root):
	game_root.start_text(["test"],self)

func is_battle(game_root):
	game_root.start_text(["battle"],self)

func is_snd(_game_root,index,codes):
	var code = codes[index]
	var index_line_str = ""
	for i in range(len("snd["),len(code)-1) :
		index_line_str += code[i]
	var index_line = int(index_line_str)
	var node_affect = extra_sound[index_line]
	node_affect.playing = true

func is_snd_stop(_game_root,index,codes):
	var code = codes[index]
	var index_line_str = ""
	for i in range(len("snd_stop["),len(code)-1) :
		index_line_str += code[i]
	var index_line = int(index_line_str)
	var node_affect = extra_sound[index_line]
	node_affect.playing = false

func is_hide(game_root,index,codes):
	var code = codes[index]
	var index_line_str = ""
	for i in range(len("hide["),len(code)-1) :
		index_line_str += code[i]
	
	var index_line = int(index_line_str)
	if index_line == 0 :
		game_root.player.hide()
	if index_line == 1 :
		game_root.player.show()

func is_disable(_game_root,index,codes):
	var code = codes[index]
	var index_line_str = ""
	for i in range(len("disable["),len(code)-1) :
		index_line_str += code[i]
	
	var index_line = int(index_line_str)
	if index_line == 0 :
		interact_disable = false
	if index_line == 1 :
		interact_disable = true

func is_block(game_root,index,codes):
	var code = codes[index]
	var index_line_str = ""
	for i in range(len("block["),len(code)-1) :
		index_line_str += code[i]
	
	var index_line = int(index_line_str)
	if index_line == 0 :
		game_root.player.set_process_mode(PROCESS_MODE_DISABLED)
	if index_line == 1 :
		game_root.player.set_process_mode(PROCESS_MODE_INHERIT)

func is_anim(_game_root,index,codes):
	var code = codes[index]
	var index_line_str = ""
	for i in range(len("anim["),len(code)-1) :
		index_line_str += code[i]
	
	animation_player.play(index_line_str)

func is_subcam(game_root,index,codes):
	var code = codes[index]
	var index_line_str = ""
	for i in range(len("subcam["),len(code)-1) :
		index_line_str += code[i]
	player_cam = game_root.player.camera
	var index_line = int(index_line_str)
	if index_line == 0 :
		use_sub_cam = false
		player_cam.position = Vector2.ZERO
	if index_line == 1 :
		use_sub_cam = true

func is_story(game_root,index,codes):
	var code = codes[index]
	var index_line_str = ""
	for i in range(len("story["),len(code)-1) :
		index_line_str += code[i]
	var index_line = int(index_line_str)
	game_root.player.story = index_line

func execute_lines(game_root,codes) :
	for line in range(len(codes)) :
		if codes[line].contains("txt[") and codes[line].contains("]") :
			is_text(game_root,line,codes)
			instru_check = true
			await game_root.dialogue_end
		
		if codes[line].contains("func[") and codes[line].contains("]") :
			is_func(game_root,line,codes)
			instru_check = true
			
		elif codes[line].contains("test[") and codes[line].contains("]") :
			is_test(game_root)
			instru_check = true
			await game_root.dialogue_end
		
		elif codes[line].contains("battle[") and codes[line].contains("]") :
			is_battle(game_root)
			instru_check = true
			await game_root.dialogue_end
		
		elif codes[line].contains("anim[") and codes[line].contains("]") :
			is_anim(game_root,line,codes)
			instru_check = true
			await animation_player.animation_finished
		
		elif codes[line].contains("bip[") and codes[line].contains("]") :
			is_bip(game_root,line,codes)
			instru_check = true
		
		elif codes[line].contains("snd[") and codes[line].contains("]") :
			is_snd(game_root,line,codes)
			instru_check = true
		
		elif codes[line].contains("block[") and codes[line].contains("]") :
			is_block(game_root,line,codes)
			instru_check = true
		
		elif codes[line].contains("snd_stop[") and codes[line].contains("]") :
			is_snd_stop(game_root,line,codes)
			instru_check = true
		
		elif codes[line].contains("hide[") and codes[line].contains("]") :
			is_hide(game_root,line,codes)
			instru_check = true
		
		elif codes[line].contains("disable[") and codes[line].contains("]") :
			is_disable(game_root,line,codes)
			instru_check = true
		
		elif codes[line].contains("subcam[") and codes[line].contains("]") :
			is_subcam(game_root,line,codes)
			instru_check = true
		
		elif codes[line].contains("story[") and codes[line].contains("]") :
			is_story(game_root,line,codes)
			instru_check = true

func interact(game_root):
	game_root.bip_index = 0
	if not interact_disable :
		execute_lines(game_root,lines)
		if not instru_check :
			game_root.start_text(["c'est pas encore fait"],self)


func _on_body_entered(body: Node2D) -> void:
	if body is Player :
		interact(body.game_root)
