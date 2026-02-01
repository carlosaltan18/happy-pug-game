extends Node2D

@export_file("*.tscn") var start_scene

func _ready():
	load_scene(start_scene)

func load_scene(scene_path: String):
	for child in $CurrentScene.get_children():
		child.queue_free()

	var scene = load(scene_path).instantiate()
	$CurrentScene.add_child(scene)
