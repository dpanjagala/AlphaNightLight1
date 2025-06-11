extends Node2D

var is_day = true
var fire_time = 90
@onready var canvas_mod = $CanvasModulate
@onready var reignite_timer = $reignite_timer
var fire_temporarily_bright = false

func _ready():
	$fire_timer.start()
	$fire_anim.play("burning")

func _on_fire_timer_timeout():
	fire_time -= 1
	$CanvasLayer/fire_label.text = "Fire Time: " + str(fire_time)

	# Fire dims at 60s
	if fire_time == 60:
		$fire_anim.play("dim")
		canvas_mod.color = Color(0.7, 0.7, 0.85, 0.75)

	# Fire idles (dark) at 30s
	if fire_time == 30:
		$fire_anim.play("idle")
		canvas_mod.color = Color(0.3, 0.3, 0.4, 0.5)

	# Pause if fire dies
	if fire_time <= 0:
		fire_time = 0
		get_tree().paused = true

func _on_fire_area_body_entered(body: Node2D) -> void:
	if body.has_meta("is_wood_log") and body.get_meta("is_wood_log") == true and body.carried_by_player:
		body.queue_free()
		Global.player_has_wood = false

		if $fire_anim.animation == "dim":
			print("🔥 Log dropped into dim fire — reigniting")
			fire_time += 20  # You can adjust this
			$fire_anim.play("burning")
			canvas_mod.color = Color(1, 1, 1, 1)  # Restore light
			$reignite_timer.start()
		else:
			print("⚠️ Fire not dimmed — log has no effect")

		fire_time += 10
		body.queue_free()
		Global.player_has_wood = false

		# Reignite fire temporarily
		$fire_anim.play("burning")
		canvas_mod.color = Color(1, 1, 1, 1)
		fire_temporarily_bright = true
		reignite_timer.start()

		# Resume game if it was paused
		if get_tree().paused:
			get_tree().paused = false
	else:
		print(" Not a valid wood or not dropped by player.")

func _on_reignite_timer_timeout():
	if $fire_anim.animation == "burning":
		$fire_anim.play("dim")
		canvas_mod.color = Color(0.3, 0.3, 0.4, 0.5)
		print("🌑 Fire dimmed again after temporary reignite")
