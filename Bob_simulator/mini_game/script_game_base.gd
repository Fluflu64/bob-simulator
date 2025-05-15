extends Node2D
var game_root = null

func quit_mini_game():
	hide()
	game_root.animation.play("transition_off")
	await game_root.animation.animation_finished
	game_root.end_battle()
	queue_free()
