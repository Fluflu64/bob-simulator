extends Node2D

var check = false
var camera_follow = false
var camera_ref = null

@onready var my_cam = $Camera2D
@onready var animation = $AnimationPlayer
@onready var forline = $forline

var lines1 = [\
"Je récapitule...",
"Tu es Bob...",
"Un detective localement renommé...",
"Et tu as finis en prison pour mensonge et atteinte aux Lord...",
"...",
"J'ai l'impression qu'il manque un truc...",
"Surtout ne bouge pas je reviens..."]

func _ready() -> void:
	if check:
		animation.play("check")

func _process(_delta: float) -> void:
	if camera_follow :
		camera_ref.position = my_cam.position + Vector2(-32,-32)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and check == false:
		check = true
		body.set_process_mode(PROCESS_MODE_DISABLED)
		body.hide()
		camera_ref = body.camera
		camera_follow = true
		animation.play("start")
		await animation.animation_finished
		body.game_root.start_text(lines1,forline)
		await body.game_root.dialogue_end
		animation.play("end")
		body.set_process_mode(PROCESS_MODE_DISABLED)
		await animation.animation_finished
		body.sprite.frame_coords = Vector2(0,4)
		body.frame_direction = 4
		camera_follow = false
		body.show()
		body.set_process_mode(PROCESS_MODE_INHERIT)
		body.story = 1

func set_check():
	check = true
