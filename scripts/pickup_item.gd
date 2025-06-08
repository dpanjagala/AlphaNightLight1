extends Area2D

var player_in_range = false
var carried_by_player = false
var offset = Vector2(0, -20)

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("pickup_item"):
		carried_by_player = true
		var player = get_node_or_null("/root/world/player")
		if player:
			get_parent().remove_child(self)
			player.add_child(self)
			scale = Vector2(0.5, 0.5)  # Keep log small even when attached to player


	if carried_by_player:
		var player = get_node_or_null("/root/world/player")
		if player:
			position = player.position + offset

			if Input.is_action_just_pressed("drop_item"):
				carried_by_player = false
				var world = get_node_or_null("/root/world")
				if world:
					get_parent().remove_child(self)
					world.add_child(self)
					global_position = player.global_position  
					scale = Vector2(0.5, 0.5) 
				else:
					print("Error: World node not found!")
		else:
			print("Error: Player node not found!")

func _on_body_entered(body):
	if body.name == "player":
		player_in_range = true

func _on_body_exited(body):
	if body.name == "player":
		player_in_range = false
func _ready():
	scale = Vector2(0.5, 0.5)  # Set original small log size when scene starts
