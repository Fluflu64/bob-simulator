extends Area2D

@onready var area = $"."

func _process(_delta: float) -> void:
	for body in area.get_overlapping_bodies() :
		if body is Player :
			if body.frame_direction == 0 or body.frame_direction == 4 :
				body.is_climb = true
				body.position.x = global_position.x
				


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.is_climb = false
