extends Area2D

@export var spawn = "truc"

func _on_body_entered(body: Node2D) -> void:
	if body is Player :
		body.game_root.start_shop(spawn)
		
