extends Area2D

var player_in_range = false
var carried_by_player = false
var offset = Vector2(0, -16)

func _ready():
	self.set_meta("is_wood_log", true)
	carried_by_player = false
	$CollisionShape2D.disabled = false  # Ensure collision is active initially

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("pickup_item") and !carried_by_player and !Global.player_has_wood:
		var player = get_node_or_null("/root/world/player")
		if player:
			var saved_pos = global_position
			carried_by_player = true
			Global.player_has_wood = true

			get_parent().remove_child(self)
			player.add_child(self)

			set_as_top_level(true)
			global_position = saved_pos
			position = offset
			scale = Vector2(0.5, 0.5)

			$CollisionShape2D.disabled = true  # Disable while carrying

	elif carried_by_player:
		position = offset
		if Input.is_action_just_pressed("drop_item"):
			var world = get_node_or_null("/root/world")
			var player = get_node_or_null("/root/world/player")
			if world and player:
				var drop_pos = player.global_position
				carried_by_player = false
				Global.player_has_wood = false

				get_parent().remove_child(self)
				world.add_child(self)
				set_as_top_level(false)
				global_position = drop_pos + Vector2(0, 10)
				scale = Vector2(0.5, 0.5)

				$CollisionShape2D.disabled = false  # Re-enable collision

				queue_free()  # 🔥 Remove log right after drop (if desired)
			else:
				print("❌ Cannot drop — world or player not found!")

func _on_body_entered(body):
	if body.name == "player":
		player_in_range = true

func _on_body_exited(body):
	if body.name == "player":
		player_in_range = false
