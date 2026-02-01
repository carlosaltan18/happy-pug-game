extends Node2D

@export var auto_thoughts: Array = []
var thoughts_played: bool = false

func _ready():
	if auto_thoughts.is_empty():
		return

	if thoughts_played:
		return

	await get_tree().process_frame
	DialogueManager.start_dialogue(auto_thoughts)
	thoughts_played = true
