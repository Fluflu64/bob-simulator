extends Area2D

class_name Mega_bulet

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position.y -= 4
	if position.y < 0 :
		queue_free()
