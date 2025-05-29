extends Node
@onready var core_player = $".."
@onready var animation = $"../animation_bob"
@onready var sprite = $"../sprite_bob"
@onready var sprite_preview = $"../sprite_bob_preview"
@onready var reflect = $"../sprite_bob_reflect"

var first_move = Vector2.ZERO
var second_move = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.show()
	sprite_preview.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	first_move = core_player.global_position
	var velocity_delta = round(second_move - first_move)
	second_move = core_player.global_position

	if not core_player.is_climb :
		if velocity_delta != Vector2.ZERO :
			if core_player.is_pushing :
				animation.play("push_walk")
			else :
				if core_player.speed == core_player.walk_speed :
					animation.play("walk")

				else :
					animation.play("run")
		else :

			animation.play("idle")
	#calcule direction
	if Vector2(sign(core_player.direction.x),sign(core_player.direction.y)) == Vector2(0,1) :
		core_player.frame_direction = 0
	if Vector2(sign(core_player.direction.x),sign(core_player.direction.y)) == Vector2(1,1) :
		core_player.frame_direction = 1
	if Vector2(sign(core_player.direction.x),sign(core_player.direction.y)) == Vector2(1,0) :
		core_player.frame_direction = 2
	if Vector2(sign(core_player.direction.x),sign(core_player.direction.y)) == Vector2(1,-1) :
		core_player.frame_direction = 3
	if Vector2(sign(core_player.direction.x),sign(core_player.direction.y)) == Vector2(0,-1) :
		core_player.frame_direction = 4
	if Vector2(sign(core_player.direction.x),sign(core_player.direction.y)) == Vector2(-1,-1) :
		core_player.frame_direction = 5
	if Vector2(sign(core_player.direction.x),sign(core_player.direction.y)) == Vector2(-1,0) :
		core_player.frame_direction = 6
	if Vector2(sign(core_player.direction.x),sign(core_player.direction.y)) == Vector2(-1,1) :
		core_player.frame_direction = 7
	
	#actualise la direction
	if not core_player.is_climb :
		sprite.frame_coords = Vector2(sprite_preview.frame_coords.x,core_player.frame_direction)
	else :
		sprite.frame_coords = sprite_preview.frame_coords
	sprite.offset = sprite_preview.offset
	reflect.frame_coords = sprite.frame_coords
