extends Area2D

@export var spawn = -2

func _on_body_entered(body: Node2D) -> void:
	if body is Player :
		body.game_root.tp_level(spawn)
		body.game_root.start_shop()
		
