extends Node2D

var check = false

@onready var animation = $AnimationPlayer
@onready var line1 = $line1
@export var music = AudioStreamPlayer
@export var music2 = AudioStreamPlayer
@export var musicsad = AudioStreamPlayer


func _ready() -> void:
	if check:
		animation.play("check")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and check == false:
		check = true
		music.playing = false
		musicsad.playing = false
		music2.playing = true
		body.set_process_mode(PROCESS_MODE_DISABLED)
		body.sprite.frame_coords = Vector2(0,6)
		animation.play("heybob")
		await animation.animation_finished
		body.game_root.start_text(line1.lines,line1)
		await body.game_root.dialogue_end
		music2.playing = false
		animation.play("follow bob")
		body.set_process_mode(PROCESS_MODE_DISABLED)
		await animation.animation_finished
		body.story = 3
		music.playing = true
		body.can_run = true
		body.set_process_mode(PROCESS_MODE_INHERIT)

func set_check():
	check = true
	music.playing = true
	musicsad.playing = false
