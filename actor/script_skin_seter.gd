extends Area2D

@export var new_texture = Texture2D



func _on_body_entered(body: Node2D) -> void:
	if body is Player :
		body.sprite.texture = new_texture
