extends Control

# Referencias a los nodos de la UI
@onready var dialogue_text = $DialogueContainer/DialogueBox/DialogueText
@onready var name_label = $DialogueContainer/DialogueBox/NameLabel
@onready var continue_button = $DialogueContainer/DialogueBox/ContinueButton

# Referencias a los personajes
@onready var left_character = $CharacterContainer/Lagrima
@onready var right_character = $CharacterContainer/PersonajeNpc

# Referencia al Audio
@onready var audio_player = $AudioStreamPlayer 
var loop_start = 3.0
var loop_end = 50.0

# Variables del sistema de diálogos
var current_dialogue_index = 0
var dialogues = []

# Colores para cada personaje
var character_colors = {
	"Protagonista": Color(1.0, 0.8, 0.6),
	"Desconocida": Color(0.8, 0.8, 0.8),
	"Narrador": Color(0.5, 0.5, 0.5),
	"Pensamiento": Color(0.7, 0.7, 1.0)
}

# Sprites de personajes
var character_sprites = {
	"Protagonista": "res://assets/personajes/lagrima.png",
	"Desconocida": "res://assets/personajes/npc.png"
}

# Posiciones de personajes
var character_positions = {
	"Protagonista": "left",
	"Desconocida": "right"
}

func _ready():
	# 1. Iniciar audio en el segundo 5
	if audio_player:
		audio_player.play(loop_start)
	
	Transition.fade_in()
	continue_button.pressed.connect(_on_continue_pressed)
	
	# Ocultar personajes al inicio
	left_character.modulate.a = 0
	right_character.modulate.a = 0
	
	load_prologo()
	show_intro_screen() # Inicia con el título

func load_prologo():
	dialogues = [
		{"character": "Desconocida", "text": "Querida, lamento mucho la pérdida de tu hijo. Era un niño tan dulce.", "is_thought": false},
		{"character": "Protagonista", "text": "Gracias.", "is_thought": false},
		{"character": "Desconocida", "text": "Si hay algo que podamos hacer para mejorar la situación, no dude en decirnos.", "is_thought": false},
		{"character": "Protagonista", "text": "...Claro.", "is_thought": false},
		{"character": "Narrador", "text": "[Se van]", "is_thought": false},
		{"character": "Protagonista", "text": "[i]Esos fueron los últimos en irse.[/i]", "is_thought": false},
		{"character": "Protagonista", "text": "[i]Todas estas personas tan falsas... me dan asco.[/i]", "is_thought": false},
		{"character": "Protagonista", "text": "[i]Detesto la forma en la que me miran, cómo me juzgan: \"ella es la pobre madre que está enterrando a su hijo\".[/i]", "is_thought": true},
		{"character": "Protagonista", "text": "[i]La mitad ni siquiera lo conocían.[/i]", "is_thought": false},
		{"character": "Protagonista", "text": "[i]...[/i]", "is_thought": false},
		{"character": "Protagonista", "text": "[i]Debo ya regresar a casa, no he dormido en los últimos días.[/i]", "is_thought": false}
	]
	current_dialogue_index = 0

# --- PANTALLAS DE TÍTULO ---

func show_intro_screen():
	name_label.text = ""
	dialogue_text.text = "[center][i]Inicio del Prólogo[/i]\nMáscaras de Duelo"
	continue_button.text = "Empezar"
	if continue_button.pressed.is_connected(_on_continue_pressed):
		continue_button.pressed.disconnect(_on_continue_pressed)
	continue_button.pressed.connect(_start_dialogue)

func _start_dialogue():
	continue_button.text = "Continuar"
	continue_button.pressed.disconnect(_start_dialogue)
	continue_button.pressed.connect(_on_continue_pressed)
	show_current_dialogue()

# --- LÓGICA DE DIÁLOGO ---

func show_current_dialogue():
	if current_dialogue_index >= dialogues.size():
		end_prologo()
		return
	var current = dialogues[current_dialogue_index]
	show_dialogue(current["character"], current["text"], current["is_thought"])

func show_dialogue(character_name: String, text: String, is_thought: bool = false):
	update_character_sprites(character_name, is_thought)
	
	if character_name == "Narrador":
		name_label.text = ""
		dialogue_text.text = "[center][i]" + text + "[/i][/center]"
		hide_all_characters()
		return
	
	if is_thought:
		name_label.text = character_name + " (pensando)"
		name_label.add_theme_color_override("font_color", character_colors["Pensamiento"])
	else:
		name_label.text = character_name
		name_label.add_theme_color_override("font_color", character_colors.get(character_name, Color.WHITE))
	
	dialogue_text.text = text

func update_character_sprites(character_name: String, is_thought: bool):
	if character_name == "Narrador":
		return

	# AISLAMIENTO: Si es pensamiento, ocultar a la desconocida y mostrar solo a la protagonista
	if is_thought:
		hide_character(right_character)
		show_character(left_character)
		return
	
	if not character_sprites.has(character_name):
		return
	
	var char_side = character_positions.get(character_name, "right")
	var sprite_path = character_sprites[character_name]
	
	if char_side == "left":
		left_character.texture = load(sprite_path)
		show_character(left_character)
		dim_character(right_character)
	else:
		right_character.texture = load(sprite_path)
		show_character(right_character)
		dim_character(left_character)

func show_character(character_node: TextureRect):
	var tween = create_tween()
	tween.tween_property(character_node, "modulate:a", 1.0, 0.3)

func dim_character(character_node: TextureRect):
	var tween = create_tween()
	tween.tween_property(character_node, "modulate:a", 0.5, 0.3)

func hide_character(character_node: TextureRect):
	var tween = create_tween()
	tween.tween_property(character_node, "modulate:a", 0.0, 0.3)

func hide_all_characters():
	hide_character(left_character)
	hide_character(right_character)

func _on_continue_pressed():
	current_dialogue_index += 1
	show_current_dialogue()

func end_prologo():
	hide_all_characters()
	show_transition_screen()

func show_transition_screen():
	dialogue_text.text = "[center][i]Fin del Prólogo[/i]\nMáscaras de Duelo"
	name_label.text = ""
	continue_button.text = "Siguiente escena"
	continue_button.pressed.disconnect(_on_continue_pressed)
	continue_button.pressed.connect(_on_next_scene)

func _on_next_scene():
	Transition.change_scene("res://scenes/gameplay/mom_scene.tscn")
	
func _process(_delta):
	# 2. Monitorear la posición para crear el bucle
	if audio_player and audio_player.playing:
		# Si la canción llega al segundo 10, vuelve al segundo 5
		if audio_player.get_playback_position() >= loop_end:
			audio_player.seek(loop_start)
