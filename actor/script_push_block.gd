extends RigidBody2D

func push(game_root):
	var player_pos = Vector2(snappedi(BobGlobal.game_root.player.position.x+8,16),snappedi(BobGlobal.game_root.player.position.y-16,16))-Vector2(8,-24)
	var my_pos = Vector2(snappedi(position.x+8,16),snappedi(position.y-16,16))-Vector2(8,-8)
	var tween = create_tween()
	var new_pos = sign(player_pos - my_pos)*-32
	tween.tween_property(self,"linear_velocity",new_pos,0.5)
	await tween.finished
	linear_velocity = Vector2.ZERO

func _process(delta: float) -> void:
	var player_pos = Vector2(snappedi(BobGlobal.game_root.player.position.x+8,16),snappedi(BobGlobal.game_root.player.position.y-16,16))-Vector2(8,-24)
	var my_pos = Vector2(snappedi(position.x+8,16),snappedi(position.y-16,16))-Vector2(8,-8)
	var new_pos = position - (player_pos - my_pos)
	$Sprite2D2.global_position = new_pos

func function(game_root,n):
	if n == 0 :
		push(game_root)
