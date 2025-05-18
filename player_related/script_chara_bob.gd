class_name Player
extends CharacterBody2D

#variable

var story = 0

const walk_speed = 50
const run_speed = 100
const bad_speed = 30
var speed = 50

var is_climb = false

var frame_direction = 0

#variable combat
var proba_battle_max = 100
var proba_battle = 100
var proba_scale_down = 0.95

var pv_max = 20
var pv = 20
var atk = 2#2
var def = 2
var lvl = 1

var can_run = true
var infos_mode = false



#Node
@onready var sprite = $sprite_bob
@onready var sprite_preview = $sprite_bob_preview
@onready var reflect = $sprite_bob_reflect
@onready var animation =$animation_bob
@onready var camera = $camera_bob
@onready var interact = $area_interact
@onready var area_teleporation = $area_teleportation

@onready var follower = preload("res://player_related/scn_follower.tscn")

@export var game_root = null

var player_pos_array:Array
var max_record:int = 256
var follower_liste = []


func _ready():
	sprite.show()
	sprite_preview.hide()
	for i in range(max_record):
		player_pos_array.append(position)
	for p in range(0):
		var inst_follower = follower.instantiate()
		inst_follower.to_follow = self
		inst_follower.dist = 16*(p+1)
		game_root.game.add_child(inst_follower)
		follower_liste.append(inst_follower)

func _physics_process(_delta):
	move()
	BobGlobal.story = story
	
	for area2d in area_teleporation.get_overlapping_areas() :
		if area2d is Teleportation :
			game_root.load_level(area2d.next_level,area2d.spawn_index)

func _input(event):
	if event.is_action_pressed("menu"):
		if not infos_mode :
			game_root.menu()
		else :
			game_root.menu_infos()
	
	if event.is_action_pressed("interact"):
		for area2d in interact.get_overlapping_areas() :
			if area2d is Interactable :
				area2d.interact(game_root)

func _process(_delta):
	update_camera()
	

func update_camera():
	camera.global_position = round(position)

func move():
	#movement basique marcher courir
	if pv > 0 :
		if Input.is_action_pressed("run") and can_run:
			speed = run_speed
		else : 
			speed = walk_speed
	else :
		speed = bad_speed
	
	var direction = Input.get_vector("left","right","up","down")
	velocity = direction*speed
	
	#animation de deplacement basique
	if not is_climb :
		if velocity != Vector2.ZERO :
			if pv > 0 :
				if speed == walk_speed :
					animation.play("walk")
					
				else :
					animation.play("run")
			else :
				animation.play("bad_walk")
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
	if not is_climb :
		sprite.frame_coords = Vector2(sprite_preview.frame_coords.x,frame_direction)
	else :
		sprite.frame_coords = sprite_preview.frame_coords
	sprite.offset = sprite_preview.offset
	reflect.frame_coords = sprite.frame_coords
	#applique les movements
	if is_climb :
		velocity =Vector2.ZERO
	if not is_climb :
		move_and_slide()
	
	update_camera()
	if velocity != Vector2.ZERO :
		player_pos_array.pop_at(0)
		
		
		for i in follower_liste :
			i.update_pos()
		player_pos_array.append(position)
	
	
func start_battle():
	if randi_range(0,100) < proba_battle :
			game_root.start_battle()
