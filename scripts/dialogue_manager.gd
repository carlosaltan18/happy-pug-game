extends Node

var dialogue_active: bool = false
var current_dialogue = null
var player_ref = null

func start_dialogue(lines: Array):
	if dialogue_active:
		return

	dialogue_active = true

	var dialogue_scene = preload("res://scenes/ui/dialogue_box.tscn")
	current_dialogue = dialogue_scene.instantiate()

	get_tree().current_scene.add_child(current_dialogue)

	current_dialogue.start_dialogue(lines)

	if player_ref:
		player_ref.can_move = false
		
	current_dialogue.dialogue_finished.connect(end_dialogue)

func end_dialogue():
	dialogue_active = false

	if player_ref:
		player_ref.can_move = true

	current_dialogue = null
