extends Area2D

var player_ref = null


func _process(_delta: float) -> void:
	if player_ref:
		player_ref.camera.global_position.y = -128+32

func _on_body_entered(body: Node2D) -> void:
	if body is Player :
		player_ref = body
