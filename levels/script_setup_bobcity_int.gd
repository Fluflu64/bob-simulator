extends Node

@export var level = Node

@onready var sprite_gaster = $"../TexGaster"

@export var playlist:Array[AudioStreamPlayer]
@export var story_music:Array[Vector2]

func set_music():
	var story = level.player.story
	for music_to_play in story_music :
		if music_to_play.x <= story :
			for music in playlist :
				music.playing = false
			if music_to_play.x > 0 :
				playlist[music_to_play.y].playing = true

func _ready() -> void:
	define_level()
	set_music()

func define_level():
	if level.root.why == 66 :
		sprite_gaster.show()
	else :
		sprite_gaster.hide()
