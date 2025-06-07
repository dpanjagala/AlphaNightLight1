extends Node2D

var is_day = true
var fire_time = 120  # Initial fire time
@onready var canvas_mod = $CanvasModulate

func _ready():
	$fire_timer.start()
	$fire_anim.play("burning")  # Start with fire burning

func _on_fire_timer_timeout():
	fire_time -= 1
	$CanvasLayer/fire_label.text = "Fire Time: " + str(fire_time)

	if fire_time <= 0:
		$fire_anim.play("idle")
		get_tree().paused = true

func _on_campfire_body_entered(body):
	if body.name == "pickup_item" and body.carried_by_player:
		fire_time += 10  # Add time when log is placed
		body.queue_free()  # Make the log disappear
		$fire_anim.play("burning")  # 🔥 Fire Reignition Still Works


func _on_day_night_timer_timeout():
	is_day = !is_day

	if is_day:
		canvas_mod.color = Color(1, 1, 1, 1)  # Day
		$fire_anim.modulate = Color(1, 1, 1, 1)  # Bright fire
		print("🌞 It's Daytime")
	else:
		canvas_mod.color = Color(0.6, 0.6, 0.8, 0.6)  # soft cool twilight feel
		$fire_anim.modulate = Color(0.5, 0.5, 0.5, 1)  # Dim fire
		print("🌙 It's Nighttime")
