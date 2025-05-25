extends Area2D

var pos_player = Vector2.ZERO

func _process(_delta: float) -> void:
	for body in get_overlapping_bodies() :
		if body is Player :
			if body.process_mode != PROCESS_MODE_DISABLED :
				pos_player = body.global_position
			
			var min_x = global_position.x - (scale.x*8)+128
			
			var max_x = global_position.x + (scale.x*8)-128
			
			var min_y = global_position.y - (scale.y*8)+128
			
			var max_y = global_position.y + (scale.y*8)-128
			
			var cam_x = clamp(round(pos_player.x),min_x,max_x)
			var cam_y = clamp(round(pos_player.y),min_y,max_y)
			body.camera.global_position = Vector2(cam_x,cam_y)
