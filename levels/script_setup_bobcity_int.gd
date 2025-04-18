extends Node

@export var level = Node

@export var scene_000 = Node
@export var scene_001 = Node
@export var scene_002 = Node
@onready var sprite_gaster = $"../TexGaster"

func _ready() -> void:
	define_level()

func define_level():
	if level.root.why == 66 :
		sprite_gaster.show()
	else :
		sprite_gaster.hide()
	if level.player.story > 0 :
		scene_002.set_check()
	if level.player.story > 1 :
		scene_000.set_check()
		level.player.can_run = false
	if level.player.story > 2 :
		scene_001.set_check()
		level.player.can_run = true
