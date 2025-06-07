extends Area2D

var player_in_range = false
var carried_by_player = false
var offset = Vector2(0, -20)  # Offset to position wood above player

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("pickup_item"):
		carried_by_player = true
		var player = get_node_or_null("/root/world/player")
		if player:
			get_parent().remove_child(self)  # Remove from world
			player.add_child(self)  # Attach to player
		else:
			print("Error: Player node not found!")

	if carried_by_player:
		var player = get_node_or_null("/root/world/player")
		if player:
			position = player.position + offset  # Follow player with offset
		if Input.is_action_just_pressed("drop_item"):
			carried_by_player = false
			var world = get_node_or_null("/root/world")
			if world:
				get_parent().remove_child(self)  # Remove from player
				world.add_child(self)  # Add back to world
				position = player.position  # Drop at player's position
			else:
				print("Error: World node not found!")

func _on_body_entered(body):
	if body.name == "player":
		player_in_range = true

func _on_body_exited(body):
	if body.name == "player":
		player_in_range = false
