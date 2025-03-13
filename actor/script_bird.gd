extends CharacterBody2D

@onready var sprite = $Sprite2D

var z_position = 0.0
var z_velocity = 0.0
var speed = 100
var jump = false
var fly = false

func _physics_process(_delta: float) -> void:
	if !fly :
		if z_position >= 0.0 and jump:
			z_velocity = -1.0
			z_position = 0.0
			
		elif z_position < 0.0 :
			z_velocity += .1
			velocity = Vector2.ZERO
			
		if randi_range(0,2) == 1 :
			jump = true
			velocity = Vector2(randi_range(-1,1),randi_range(-1,1))*speed
		else :
			jump = false
		
		move_and_slide()
		
		z_position += z_velocity
		sprite.position.y = z_position
	else :
		position += Vector2(64,64)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == Player :
		fly = true
		print("oui")
