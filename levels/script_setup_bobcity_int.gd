extends Node

@export var level = Node

@onready var sprite_gaster = $"../TexGaster"


func _ready() -> void:
	define_level()

func define_level():
	if level.root.why == 66 :
		sprite_gaster.show()
	else :
		sprite_gaster.hide()
	if level.player.story > 0 :
		pass
	if level.player.story > 1 :
		
		level.player.can_run = false
	if level.player.story > 2 :
		
		level.player.can_run = true
