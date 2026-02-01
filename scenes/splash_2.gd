extends Node2D

func _ready():
	# Fade IN (negro → transparente)
	$ColorRect.modulate.a = 1
	var fade_in = create_tween()
	fade_in.tween_property($ColorRect, "modulate:a", 0, 1.5)

	# Audio
	$AudioStreamPlayer2D.play()

	# Esperar antes del fade out
	await get_tree().create_timer(2.0).timeout

	# Fade OUT (transparente → negro)
	var fade_out = create_tween()
	fade_out.tween_property($ColorRect, "modulate:a", 1, 1.0)
	$Timer.timeout.connect(on_timeout)
func on_timeout():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
