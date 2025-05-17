extends Node3D

@onready var camera = $"Caméra"
@onready var animation_player = $AnimationPlayer

func play(string):
	animation_player.play(string)
