extends Sprite2D

@onready var parent = $".."

var pressing = false
var max_len = 100
var dead_zone = 5

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if pressing :
		if get_global_mouse_position().distance_to(parent.global_position) <= max_len :
			global_position = get_global_mouse_position()
		else :
			var angle = parent.global_position.angle_to_point(get_global_mouse_position())
			global_position.x = parent.global_position.x + cos(angle)*max_len
			global_position.y = parent.global_position.y + sin(angle)*max_len
	else :
		global_position = lerp(global_position,parent.global_position,delta*10)
	
	var dir = global_position - parent.global_position
	dir = round(dir/100)


func _on_button_button_down() -> void:
	pressing = true


func _on_button_button_up() -> void:
	pressing = false
