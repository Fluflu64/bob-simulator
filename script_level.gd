class_name Map
extends Node2D

@export var map_name = "gobzob"
@export var encounter_rate = 100 #%
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
	
