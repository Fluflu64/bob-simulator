extends SubViewportContainer

@onready var pointer = $SubViewport/Camera3D/CSGSphere3D
var speed = 2
var box_scale = 38
var box_scale_alpha = 15
var player_box_x = -0.011
var player_box_y = -0.011
var alpha_player = 0.5
@onready var spaceship = $"../SubViewportContainer2/SubViewport3/Camera3D/yes_guy"
@onready var camera = $SubViewport/Camera3D
@onready var sprite = $"../SubViewportContainer3/SubViewport2/Camera3D/Sprite3D"

@onready var level_1 = $SubViewport/yes_level_1

func _ready() -> void:
	level_1.play("CaméraAction")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	camera.transform = level_1.camera.transform
	var direction = Input.get_vector("left","right","down","up")
	pointer.position += Vector3(direction.x,direction.y,0) * speed
	
	pointer.position.x = clamp(pointer.position.x,-box_scale,box_scale)
	pointer.position.y = clamp(pointer.position.y,-box_scale,box_scale)
	if pointer.position.x > -box_scale_alpha and pointer.position.x < box_scale_alpha and pointer.position.y > -box_scale_alpha and pointer.position.y < box_scale_alpha :
		alpha_player = (0.5+alpha_player)/2
	else :
		alpha_player = (1+alpha_player)/2
	$"../SubViewportContainer2".self_modulate = Color(1,1,1,alpha_player)
	sprite.position = pointer.position
	spaceship.position = lerp(spaceship.position,Vector3(pointer.position.x*player_box_x,pointer.position.y*player_box_y,-1),0.1)
	spaceship.look_at_from_position(spaceship.global_position,sprite.global_position)
