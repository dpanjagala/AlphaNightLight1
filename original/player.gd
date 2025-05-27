extends CharacterBody2D

var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true
var attack_ip = false

const SPEED = 200
var current_dir = "none"

@onready var anim = $AnimatedSprite2D
@onready var deal_attack_timer = $deal_attack_timer 
@onready var cam = $Camera2D


func _ready():
	cam.make_current()
	anim.scale = Vector2(2, 2) 
	anim.play("front_idle")
	print(" deal_attack_timer is: ", deal_attack_timer) 
	print(" Camera2D is: ", cam)
	

func _physics_process(delta):
	if player_alive:
		player_movement(delta)
		enemy_attack()
		attack()

		if health <= 0:
			player_alive = false
			health = 0
			print("Player has been killed")
			self.queue_free()

func player_movement(delta):
	var moving = false

	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		velocity.x = SPEED
		velocity.y = 0
		moving = true
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		velocity.x = -SPEED
		velocity.y = 0
		moving = true
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		velocity.y = SPEED
		velocity.x = 0
		moving = true
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		velocity.y = -SPEED
		velocity.x = 0
		moving = true
	else:
		velocity = Vector2.ZERO

	play_anim(moving)
	move_and_slide()

func play_anim(moving: bool):
	if attack_ip:
		return  # Don't interrupt attack animations

	match current_dir:
		"right":
			anim.flip_h = false
			anim.play("side_walk" if moving else "side_idle")
		"left":
			anim.flip_h = true
			anim.play("side_walk" if moving else "side_idle")
		"down":
			anim.flip_h = false
			anim.play("front_walk" if moving else "front_idle")
		"up":
			anim.flip_h = false
			anim.play("back_walk" if moving else "back_idle")

func player():
	pass

func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.has_method("enemy"):
		enemy_in_attack_range = true

func _on_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.has_method("enemy"):
		enemy_in_attack_range = false

func enemy_attack(): 
	if enemy_in_attack_range and enemy_attack_cooldown:
		health -= 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print("Player health:", health)

func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true

func attack():
	var dir = current_dir

	if Input.is_action_just_pressed("attack"):
		Global.player_current_attack = true 
		attack_ip = true

		match dir:
			"right":
				anim.flip_h = false
				anim.play("side_attack")
			"left":
				anim.flip_h = true
				anim.play("side_attack")
			"down":
				anim.play("front_attack")
			"up":
				anim.play("back_attack")

		if deal_attack_timer:
			deal_attack_timer.start()
		else:
			print(" Timer is missing at runtime.")

func _on_deal_attack_timer_timeout() -> void:
	if deal_attack_timer:
		deal_attack_timer.stop()

	Global.player_current_attack = false
	attack_ip = false





				
