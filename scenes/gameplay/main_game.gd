extends Control

@onready var debug_label = $DebugLabel
@onready var dialogue_text = $DialogueContainer/DialogueBox/DialogueText
@onready var name_label = $DialogueContainer/DialogueBox/NameLabel
@onready var continue_button = $DialogueContainer/DialogueBox/ContinueButton

func _ready():
	Transition.fade_in()

	print("Escena del juego cargada correctamente")
	continue_button.pressed.connect(_on_continue_pressed)
	
	# Mostrar un diálogo de prueba
	show_dialogue("Protagonista", "El funeral fue ayer. Hoy es el primer día del resto de mi vida sin él.")

func show_dialogue(character_name: String, text: String):
	name_label.text = character_name
	dialogue_text.text = text

func _on_continue_pressed():
	print("Botón continuar presionado")
	# Aquí irá la lógica del sistema de diálogos
	show_dialogue("Protagonista", "[i]¿Por qué todos me miran así?[/i]")
