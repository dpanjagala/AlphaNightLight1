extends CharacterBody2D

var speed = 40
var player_chase = false
var player = null

var health = 100
var player_inattack_zone = false
var can_take_damage = true

func _ready():
	$AnimatedSprite2D.scale = Vector2(2, 2)

func _physics_process(delta):
	deal_with_damage()
	update_health() 

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

func deal_with_damage():
	if player_inattack_zone and Global.player_current_attack == true and can_take_damage:
		health -= 20
		$take_damage_cooldown.start()
		can_take_damage = false
		print("💥 Slime health =", health)

		if health <= 0:
			reset_player_attack_animation()
			queue_free()

func reset_player_attack_animation():
	if player != null:
		player.attack_ip = false
		Global.player_current_attack = false
		print("✅ attack_ip reset for player")

func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true

func update_health():
	var healthbar = $healthbar

	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true


	
