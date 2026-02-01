extends Node

var is_transitioning: bool = false
var fade_scene := preload("res://transitions/Fade.tscn")

func change_scene(scene_path: String):
	if is_transitioning:
		return

	is_transitioning = true

	var fade = fade_scene.instantiate()
	get_tree().current_scene.add_child(fade)

	await fade.fade_out()

	get_tree().change_scene_to_file(scene_path)

	await get_tree().process_frame

	var new_fade = fade_scene.instantiate()
	get_tree().current_scene.add_child(new_fade)

	await new_fade.fade_in()

	is_transitioning = false
