class_name Map
extends Node2D

@export var map_name = "gobzob"
@export var encounter_rate = 100 #%
@export var encounter = [0]
@export var spawn = []

func get_spawn_by_id(index:int):
	return get_node(spawn[index]).position
