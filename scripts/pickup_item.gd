extends Area2D

var player_in_range = false

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("pickup_item"):
		Global.player_has_wood = true
		queue_free()

func _on_body_entered(body):
	if body.name == "player":
		player_in_range = true

func _on_body_exited(body):
	if body.name == "player":
		player_in_range = false
