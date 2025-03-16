extends CanvasLayer

@onready var game_viewport = $background_canvas/gameview_canvas

func _process(_delta: float) -> void:
	print(get_viewport().size)
	var viewscale = get_viewport().size.y/256
	game_viewport.scale = Vector2(viewscale,viewscale)
	game_viewport.position = Vector2(1280-viewscale*128,720-viewscale*128)
