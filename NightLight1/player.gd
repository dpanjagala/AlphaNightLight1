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
	if cam and cam.has_method("make_current"):
		cam.make_current()
	else:
		print("⚠️ Camera2D not found or not ready.")

	anim.scale = Vector2(2, 2)
	anim.play("front_idle")
	print(" deal_attack_timer is: ", deal_attack_timer)
	print(" Camera2D is: ", cam)


func _physics_process(delta):
	if player_alive:
		player_movement(delta)
		enemy_attack()
		attack()

		if Global.player_has_wood and Input.is_action_just_pressed("drop_item"):
			drop_item()
			print("current_dir:", current_dir)

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

func _on_AnimatedSprite2D_animation_finished():
	if anim.animation == "side_attack" or anim.animation == "front_attack" or anim.animation == "back_attack":
		attack_ip = false

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
		attack_ip = true
		Global.player_current_attack = true  

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

func _on_deal_attack_timer_timeout() -> void:
	if deal_attack_timer:
		deal_attack_timer.stop()

	Global.player_current_attack = false
	attack_ip = false

	match current_dir:
		"right":
			anim.flip_h = false
			anim.play("side_idle")
		"left":
			anim.flip_h = true
			anim.play("side_idle")
		"down":
			anim.play("front_idle")
		"up":
			anim.play("back_idle")

	print("✅ Attack finished ")


func drop_item():
	Global.player_has_wood = false

	var item_scene = preload("res://scenes/pickup_item.tscn")
	var dropped_item = item_scene.instantiate()
	
	var world = get_tree().get_root().get_node("world")
	world.add_child(dropped_item)
	dropped_item.global_position = self.global_position  

	print("🪵 Dropped log at:", dropped_item.global_position)



				
