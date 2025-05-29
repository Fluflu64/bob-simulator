extends StaticBody2D


@onready var col_left = $left
@onready var col_right = $right
@onready var col_up = $up
@onready var col_down = $down
@onready var raycast = $ray
@onready var animation = $AnimationPlayer
@onready var dust = $GPUParticles2D
@onready var audio = $AudioStreamPlayer2D/AudioStreamPlayer

func push(_game_root):
	var new_pos = position
	
	for body in col_left.get_overlapping_bodies() :
		if body is Player :
			new_pos += Vector2(16,0)
			raycast.target_position = Vector2(16,0)
	
	for body in col_right.get_overlapping_bodies() :
		if body is Player :
			new_pos += Vector2(-16,0)
			raycast.target_position = Vector2(-16,0)
	
	for body in col_up.get_overlapping_bodies() :
		if body is Player :
			new_pos += Vector2(0,16)
			raycast.target_position = Vector2(0,16)
	
	for body in col_down.get_overlapping_bodies() :
		if body is Player :
			new_pos += Vector2(0,-16)
			raycast.target_position = Vector2(0,-16)
	animation.play("start_push")
	await animation.animation_finished
	
	if not raycast.is_colliding() :
		dust.emitting = true
		audio.playing = true
		var tween = create_tween()
		tween.tween_property(self,"position",new_pos,0.5)
		await tween.finished
		dust.emitting = false

func function(game_root,n):
	if n == 0 :
		push(game_root)
