extends Area2D

@onready var area = $"."

func _process(delta: float) -> void:
	for body in area.get_overlapping_bodies() :
		if body is Player :
			body.is_climb = true
			if body.velocity == Vector2.ZERO :
				body.animation.play("idle rope")
			else : 
				body.animation.play("climb rope")


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.is_climb = false
