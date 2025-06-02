extends Node2D

var fire_time = 60  # Initial fire time

func _ready():
	$fire_timer.start()
	$fire_anim.play("burning")  # Start with no flame

func _on_fire_timer_timeout():
	fire_time -= 1
	$CanvasLayer/fire_label.text = "Fire Time: " + str(fire_time)

	if fire_time <= 0:
		$fire_anim.play("idle")
		get_tree().paused = true

func _on_glowing_wood_body_entered(body):
	if body.name == "player" and Global.player_has_wood:
		fire_time += 10
		Global.player_has_wood = false

		$fire_anim.play("starting")
		await $fire_anim.animation_finished
		$fire_anim.play("burning")


func _on_pickup_item_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
