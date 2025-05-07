extends Node3D

@onready var animation = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("Actions réservées]_001") 
	
func _process(delta: float) -> void:
	rotate(Vector3(0,1,0),0.1)
