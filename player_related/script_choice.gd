extends CanvasLayer

var lines_text_box = []
@onready var text = $RichTextLabel
@onready var hand = $Node2D

var index = 0

func _ready() -> void:
	text.text = ""
	for choice in lines_text_box :
		text.text += BobGlobal.langue[BobGlobal.langindex][int(choice)] + "\n\n"


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		queue_free()
	if event.is_action_pressed("up"):
		index -= 1
	if event.is_action_pressed("down"):
		index += 1
	index = clampi(index,0,len(lines_text_box)-1)
	hand.position = Vector2(240,8 + index*16)
	BobGlobal.choice = index
