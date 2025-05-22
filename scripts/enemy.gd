extends CharacterBody2D

var speed = 40
var player_chase = false
var player = null

var health = 100
var player_inattack_zone = false

func _physics_process(delta):
	
	if player_chase and player:
		var direction = (player.position - position).normalized()
		velocity = direction * speed
		move_and_slide()

		$AnimatedSprite2D.play("walk")

		if player.position.x - position.x < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		velocity = Vector2.ZERO
		move_and_slide()
		$AnimatedSprite2D.play("idle")

func _on_detection_area_body_entered(body):
	print("Detected: ", body.name)
	player = body
	player_chase = true

func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
	
func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = true

func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = false
