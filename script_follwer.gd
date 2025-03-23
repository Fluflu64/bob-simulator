extends CharacterBody2D

var to_follow:CharacterBody2D
var dist = 16

func update_pos():
	position = round(to_follow.player_pos_array[254-dist])
