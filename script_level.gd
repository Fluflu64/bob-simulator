class_name Map
extends Node2D

@export var map_name = "gobzob"
@export var encounter_rate = 100 #%
@export var battle_theme = preload("res://music/mus_battle_test.ogg")
@export var battle_color:Color = Color(0.769,0.62,0.291,1)
@export var encounter = [0]
@onready var node_spawn_list = $spawn
var spawn = []

var lines =[\
"je suis une ligne de texte",
"je suis a but de test"
]

@onready var player = null
@onready var root = null

func test():
	pass

func get_spawn_by_id(spawn_name:String):
	for node in node_spawn_list.get_children():
		if node.name == spawn_name :
			return node.position
	
