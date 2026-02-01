extends Area2D

@export_file("*.tscn") var next_scene

func interact():
	if DialogueManager.dialogue_active:
		return

	TransitionManager.change_scene(next_scene)
