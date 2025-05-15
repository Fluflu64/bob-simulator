extends Node2D

@onready var mini_game_core = $".."
@onready var player = $Area2D2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("left"):
		player.position.x -= 4
	if Input.is_action_pressed("right"):
		player.position.x += 4
	if Input.is_action_just_pressed("run"):
		mini_game_core.quit_mini_game()
