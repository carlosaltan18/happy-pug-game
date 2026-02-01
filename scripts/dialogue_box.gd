extends CanvasLayer

@onready var name_label: Label = $Panel/NameLabel
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
	name_label.text = line["name"]
	text_label.text = line["text"]

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
