extends Node2D
@onready var animation = $AnimationPlayer
@export var active = false

var index = 0

@onready var menu_label = $Label
@onready var load_label = $Label2

signal load

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("game over")
	menu_label.text = BobGlobal.langue[BobGlobal.langindex][38] + "<"
	load_label.text = BobGlobal.langue[BobGlobal.langindex][34]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if active :
		if Input.is_action_just_pressed("left") :
			index = 0
			menu_label.text = BobGlobal.langue[BobGlobal.langindex][38] + "<"
			load_label.text = BobGlobal.langue[BobGlobal.langindex][34]
		
		if Input.is_action_just_pressed("right") :
			index = 1
			menu_label.text = BobGlobal.langue[BobGlobal.langindex][38]
			load_label.text = BobGlobal.langue[BobGlobal.langindex][34] + "<"
		
		if Input.is_action_just_pressed("interact"):
			if index == 0 :
				BobGlobal.game_root.end_game()
				queue_free()
			if index == 1 :
				BobGlobal.game_root.load_game()
				#queue_free()
			
