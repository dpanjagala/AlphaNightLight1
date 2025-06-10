extends Node2D

var is_day = true
var fire_time = 90
@onready var canvas_mod = $CanvasModulate
@onready var reignite_timer = $reignite_timer

func _ready():
	$fire_timer.start()
	$fire_anim.play("burning")

func _on_fire_timer_timeout():
	fire_time -= 1
	$CanvasLayer/fire_label.text = "Fire Time: " + str(fire_time)

	if fire_time == 60:
		$fire_anim.play("dim")
		canvas_mod.color = Color(0.7, 0.7, 0.85, 0.75)

	if fire_time == 30:
		$fire_anim.play("idle")
		canvas_mod.color = Color(0.3, 0.3, 0.4, 0.5)

	if fire_time <= 0:
		get_tree().paused = true

func _on_wood_detection_area_body_entered(body):
	if body.name.begins_with("pickup_item"):
		print("🔥 Reigniting fire!")
		body.queue_free()
		Global.player_has_wood = false
		fire_time = 20
		reignite()

func reignite():
	$fire_anim.play("burning")
	canvas_mod.color = Color(1, 1, 1, 1)
	reignite_timer.start()
	print("🔥 Fire reignited for 20 seconds!")

func _on_reignite_timer_timeout():
	$fire_anim.play("dim")
	canvas_mod.color = Color(0.3, 0.3, 0.4, 0.5)
	print("🌒 Fire dimmed after 20 seconds")
