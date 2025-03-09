extends CanvasLayer

@onready var label = $NinePatchRect/MarginContainer/Label
@onready var timer = $letter_timer
@onready var bip = $audio_player/bip

var lines_text_box = [\
"Hello again. To reiterate [slows down] our previous [speeds up] warning: This test [garbled speech] -ward momentum.",
"Spectacular. You appear to understand how a portal affects forward momentum, or to be more precise, how it does not." ,
"Momentum, a function of mass and velocity, is conserved between portals. In layman's terms, speedy thing goes in, speedy thing comes out."
]

var box_text = ""
var letter_index = 0

var line_index = 0

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
	label.text = ""
	box_text = ""
	letter_index = 0
	timer.start()


func _letter_write() -> void:
	bip.play()
	box_text += lines_text_box[line_index][letter_index]
	label.text = box_text
	letter_index += 1
	if letter_index < len(lines_text_box[line_index]) :
		timer.start()
