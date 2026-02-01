extends CanvasLayer

@onready var name_label: Label = $Panel/Name
@onready var text_label: RichTextLabel = $Panel/TextLabel

var dialogue_lines: Array = []
var current_index: int = 0
var is_active: bool = false
signal dialogue_finished


func start_dialogue(lines: Array):
	dialogue_lines = lines
	current_index = 0
	is_active = true
	show()

	show_current_line()
	
func show_current_line():
	if current_index >= dialogue_lines.size():
		end_dialogue()
		return

	var line = dialogue_lines[current_index]

	# Caso 1: línea como Dictionary (NPCs)
	if line is Dictionary:
		name_label.text = line.get("name", "")
		text_label.text = line.get("text", "")
	
	# Caso 2: línea como String (pensamientos simples)
	elif line is String:
		name_label.text = "Pensamientos"
		text_label.text = line


func _input(event):
	if not is_active:
		return

	if event.is_action_pressed("advance_dialogue"):
		current_index += 1
		show_current_line()

func end_dialogue():
	is_active = false
	hide()
	dialogue_finished.emit()
	queue_free()
