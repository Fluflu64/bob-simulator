extends CharacterBody2D

@export var follow = Node
@onready var timer = $Timer
var dist_max = 1
var follower_loc = []

func dist_to(pos1:Vector2,pos2:Vector2):
	return sqrt((pos2.x - pos1.x)**2+(pos2.y-pos1.y)**2)

func _ready() -> void:
	follower_loc.append(follow.global_position)

func _physics_process(delta: float) -> void:
	
		
	if dist_to(follow.global_position,global_position)>dist_max:
		global_position = follow.global_position
		
	

func _on_timer_timeout() -> void:
	follower_loc.pop_at(0)
