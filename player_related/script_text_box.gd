extends CanvasLayer

@onready var label = $NinePatchRect/MarginContainer/RichTextLabel
@onready var timer = $letter_timer
@onready var bip = $audio_player/bip_base
@onready var animation = $AnimationPlayer

@onready var bip_base = $audio_player/bip_base
@onready var bip_bonjour = $audio_player/bip_bonjour
@onready var bip_fluflu = $audio_player/bip_fluflu
@onready var bip_foxy = $audio_player/bip_foxy
@onready var bip_hue = $audio_player/bip_hue
@onready var bip_spam = $audio_player/bip_spambob

@onready var liste_bip =[\
bip_base,
bip_bonjour,
bip_fluflu,
bip_foxy,
bip_hue,
bip_spam]

var lines_text_box = [\
"Hello again. To reiterate [slows down] our previous [speeds up] warning: This test [garbled speech] -ward momentum.",
"Spectacular. You appear to understand how a portal affects forward momentum, or to be more precise, how it does not." ,
"Momentum, a function of mass and velocity, is conserved between portals. In layman's terms, speedy thing goes in, speedy thing comes out."
]

var box_text = ""
var letter_index = 0

var line_index = 0

var text_bip_index = 0

func set_bip(bip_index):
	text_bip_index = bip_index

func _ready() -> void:
	write()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if line_index < len(lines_text_box)-1 :
			line_index += 1
			write()
		else :
			queue_free()
	

func write():
	animation.play("RESET")
	label.visible_characters = 0
	label.text = lines_text_box[line_index]
	box_text = ""
	letter_index = 0
	timer.start()


func _letter_write() -> void:
	#liste_bip[text_bip_index].pitch_scale = randf_range(.9,1.1)
	liste_bip[text_bip_index].play()
	
	letter_index += 1
	
	label.visible_characters = letter_index
	if letter_index < label.get_total_character_count() :
		timer.start()
	else :
		animation.play("cursor")
