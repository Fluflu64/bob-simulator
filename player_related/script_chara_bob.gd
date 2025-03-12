class_name Player
extends CharacterBody2D

#variable

const walk_speed = 50
const run_speed = 100
var speed = 50

var frame_direction = 0

#variable combat
var proba_battle_max = 100
var proba_battle = 100
var proba_scale_down = 0.95

var pv_max = 20
var pv = 20
var atk = 2
var def = 2

#Node
@onready var sprite = $sprite_bob
@onready var sprite_preview = $sprite_bob_preview
@onready var reflect = $sprite_bob_reflect
@onready var animation =$animation_bob
@onready var camera = $camera_bob
@onready var interact = $area_interact
@onready var area_teleporation = $area_teleportation

@export var game_root = null

func _ready():
	sprite.show()
	sprite_preview.hide()

func _physics_process(_delta):
	move()
	if velocity != Vector2.ZERO :
		if randi_range(0,100) < proba_battle :
			game_root.start_battle()
	for area2d in area_teleporation.get_overlapping_areas() :
		if area2d is Teleportation :
			game_root.load_level(area2d.next_level,area2d.spawn_index)

func _input(event):
	if event.is_action_pressed("menu"):
		game_root.menu()
	
	if event.is_action_pressed("interact"):
		for area2d in interact.get_overlapping_areas() :
			if area2d is Interactable :
				game_root.start_text(area2d.lines,area2d)

func _process(_delta):
	update_camera()

func update_camera():
	camera.global_position = round(position)

func move():
	#movement basique marcher courir
	if Input.is_action_pressed("run") :
		speed = run_speed
	else : 
		speed = walk_speed
	var direction = Input.get_vector("left","right","up","down")
	velocity = direction*speed
	
	#animation de deplacement basique
	if velocity != Vector2.ZERO :
		if speed == walk_speed :
			animation.play("walk")
		else :
			animation.play("run")
	else :
		animation.play("idle")
	
	if velocity != Vector2.ZERO :
		interact.position = sign(velocity)*8
	
	#calcule direction
	if Vector2(sign(direction.x),sign(direction.y)) == Vector2(0,1) :
		frame_direction = 0
	if Vector2(sign(direction.x),sign(direction.y)) == Vector2(1,1) :
		frame_direction = 1
	if Vector2(sign(direction.x),sign(direction.y)) == Vector2(1,0) :
		frame_direction = 2
	if Vector2(sign(direction.x),sign(direction.y)) == Vector2(1,-1) :
		frame_direction = 3
	if Vector2(sign(direction.x),sign(direction.y)) == Vector2(0,-1) :
		frame_direction = 4
	if Vector2(sign(direction.x),sign(direction.y)) == Vector2(-1,-1) :
		frame_direction = 5
	if Vector2(sign(direction.x),sign(direction.y)) == Vector2(-1,0) :
		frame_direction = 6
	if Vector2(sign(direction.x),sign(direction.y)) == Vector2(-1,1) :
		frame_direction = 7
	
	#actualise la direction
	sprite.frame_coords = Vector2(sprite_preview.frame_coords.x,frame_direction)
	sprite.offset = sprite_preview.offset
	reflect.frame_coords = sprite.frame_coords
	
	#applique les movements
	move_and_slide()
	
	update_camera()
