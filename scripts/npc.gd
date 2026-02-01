extends Node2D
#dialogo
func interact():
	var dialogue = [
		{"name":"Random","text":"Lo siento mucho..."}
	]

	DialogueManager.start(dialogue)
