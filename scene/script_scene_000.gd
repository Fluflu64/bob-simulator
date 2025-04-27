extends Node2D

var check = false

@onready var animation = $AnimationPlayer
@onready var line1 = $line1
@onready var line2 = $line2
@onready var line3 = $line3
@onready var rain = $GPUParticles2D
@onready var sprite = $Sprite2D
@export var intro_bgm = AudioStreamPlayer
@export var music = AudioStreamPlayer
@export var musicsad = AudioStreamPlayer

func _ready() -> void:
	if check:
		animation.play("check")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and check == false:
		check = true
		body.set_process_mode(PROCESS_MODE_DISABLED)
		body.sprite.frame_coords = Vector2(0,4)
		animation.play("flic1")
		await animation.animation_finished
		body.game_root.start_text(line1.lines,line1)
		await body.game_root.dialogue_end
		music.playing = false
		animation.play("flic2")
		body.set_process_mode(PROCESS_MODE_DISABLED)
		await animation.animation_finished
		body.game_root.start_battle()
		body.set_process_mode(PROCESS_MODE_INHERIT)
		await body.game_root.battle_end
		body.sprite.frame_coords = Vector2(0,4)
		animation.play("flic3")
		body.set_process_mode(PROCESS_MODE_DISABLED)
		await animation.animation_finished
		body.game_root.start_text(line2.lines,line2)
		await body.game_root.dialogue_end
		musicsad.playing = true
		rain.emitting = true
		body.game_root.start_text(line3.lines,line3)
		await body.game_root.dialogue_end
		animation.play("flic4")
		body.set_process_mode(PROCESS_MODE_DISABLED)
		await animation.animation_finished
		body.set_process_mode(PROCESS_MODE_INHERIT)
		body.can_run = false
		rain.emitting = false
		body.story = 2

func set_check():
	check = true
	music.playing = false
	musicsad.playing = true
	intro_bgm.playing = false
