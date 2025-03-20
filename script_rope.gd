extends Area2D

@onready var area = $"."

func _process(_delta: float) -> void:
	for body in area.get_overlapping_bodies() :
		if body is Player :
			if body.frame_direction == 0 or body.frame_direction == 4 :
				body.is_climb = true
				var mov_dir = Input.get_axis("down","up")
				body.velocity =Vector2.ZERO
				body.position.y+= mov_dir*-1
				body.position.x = global_position.x
				if mov_dir == 0:
					body.animation.play("idle rope")
				else : 
					body.animation.play("climb rope")


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.is_climb = false
