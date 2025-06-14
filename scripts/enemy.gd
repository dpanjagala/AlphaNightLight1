extends CharacterBody2D

var speed = 40
var player_chase = false
var player = null

var health = 100
var max_health = 100
var player_inattack_zone = false
var can_take_damage = true

func _ready():
	$AnimatedSprite2D.scale = Vector2(2, 2)
	$healthbar.max_value = max_health
	$healthbar.value = max_health
	$healthbar.visible = false  

func _physics_process(delta):
	deal_with_damage()
	update_health()

	if player_chase and player:
		var direction = (player.position - position).normalized()
		velocity = direction * speed
		move_and_slide()
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = player.position.x < position.x
	else:
		velocity = Vector2.ZERO
		move_and_slide()
		$AnimatedSprite2D.play("idle")

func _on_detection_area_body_entered(body):
	if body.name == "player":
		player = body
		player_chase = true

func _on_detection_area_body_exited(body):
	if body.name == "player":
		player = null
		player_chase = false

func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player_inattack_zone = true

func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player_inattack_zone = false

func deal_with_damage():
	if Global.player_current_attack == true and can_take_damage:
		var overlapping = $enemy_hitbox.get_overlapping_bodies()
		for body in overlapping:
			if body.name == "player":
				health -= 20
				$take_damage_cooldown.start()
				can_take_damage = false
				print("Slime health =", health)

				if health <= 0:
					queue_free()

func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true

func update_health():
	var healthbar = $healthbar

	healthbar.value = health

	if health < max_health:
		healthbar.visible = true
		








	
