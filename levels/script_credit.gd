extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("credit_anim")
	await animation_finished
	BobGlobal.game_root.end_game()
