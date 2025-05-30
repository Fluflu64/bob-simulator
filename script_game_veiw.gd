extends CanvasLayer

@onready var game_viewport = $background_canvas/gameview_canvas
@onready var mobil_input = $Node2D

var display_mode = DisplayServer.window_get_mode()

var game_size = 1

func _process(_delta: float) -> void:
	var viewscale = get_viewport().size.y/256
	game_viewport.scale = Vector2(viewscale,viewscale)
	game_viewport.position = Vector2(1280-viewscale*128,720-viewscale*128)
	
	mobil_input.position = Vector2(get_viewport().size.x/2,get_viewport().size.y/2)
	mobil_input.scale = Vector2(viewscale,viewscale)*5
	if Input.is_action_just_pressed("full_screen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(display_mode)
		else:
			display_mode = DisplayServer.window_get_mode()
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
