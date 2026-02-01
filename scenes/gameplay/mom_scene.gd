extends Control

# Referencias a los nodos de la UI
@onready var dialogue_text = $DialogueContainer/DialogueBox/DialogueText
@onready var name_label = $DialogueContainer/DialogueBox/NameLabel
@onready var continue_button = $DialogueContainer/DialogueBox/ContinueButton

# Referencias a los personajes
@onready var left_character = $CharacterContainer/Lagrima
@onready var right_character = $CharacterContainer/Madre

@onready var audio_player = $AudioStreamPlayer 
var loop_start = 4.0
var loop_end = 50.0

# Variables del sistema de diálogos
var current_dialogue_index = 0
var dialogues = []

# Colores para cada personaje
var character_colors = {
	"Protagonista": Color(1.0, 0.8, 0.6),
	"Mamá": Color(1.0, 0.7, 0.7),
	"Narrador": Color(0.5, 0.5, 0.5),
	"Pensamiento": Color(0.7, 0.7, 1.0)
}

# Sprites de personajes
var character_sprites = {
	"Protagonista": "res://assets/personajes/lagrima.png",
	"Mamá": "res://assets/personajes/madre.png"
}

# Posiciones de personajes
var character_positions = {
	"Protagonista": "left",
	"Mamá": "right"
}

func _ready():
	if audio_player:
		audio_player.play(loop_start)
	Transition.fade_in()
	continue_button.pressed.connect(_on_continue_pressed)
	
	# Estado inicial invisible
	left_character.modulate.a = 0
	right_character.modulate.a = 0
	
	load_prologo()
	# Iniciamos con la pantalla de título en lugar del diálogo directo
	show_intro_screen()

func load_prologo():
	dialogues = [
		{"character": "Mamá", "text": "Hija... el taxi está afuera. Es hora de irnos.", "is_thought": false},
		{"character": "Protagonista", "text": "Un momento más, por favor.", "is_thought": false},
		{"character": "Mamá", "text": "Cariño, quedarnos aquí no lo traerá de vuelta. Necesitas descansar.", "is_thought": false},
		{"character": "Protagonista", "text": "...Lo sé.", "is_thought": false},
		{"character": "Narrador", "text": "[Caminan hacia la salida]", "is_thought": false},
		{"character": "Protagonista", "text": "[i]Siento un vacío que me quema el pecho.[/i]", "is_thought": true},
		{"character": "Protagonista", "text": "[i]¿Cómo puede el mundo seguir girando como si nada hubiera pasado?[/i]", "is_thought": true},
		{"character": "Protagonista", "text": "[i]Todas esas personas con sus flores y sus caras de lástima...[/i]", "is_thought": true},
		{"character": "Protagonista", "text": "[i]No entienden nada.[/i]", "is_thought": true},
		{"character": "Protagonista", "text": "[i]...[/i]", "is_thought": true},
		{"character": "Protagonista", "text": "[i]Adiós, pequeño mío.[/i]", "is_thought": true}
	]
	current_dialogue_index = 0

# --- PANTALLAS DE TÍTULO ---

func show_intro_screen():
	name_label.text = ""
	dialogue_text.text = "[center][i]Inicio Capítulo 1[/i]\nAmor de Madre"
	continue_button.text = "Empezar"
	# Cambiamos la conexión para que al pulsar vaya al primer diálogo
	if continue_button.pressed.is_connected(_on_continue_pressed):
		continue_button.pressed.disconnect(_on_continue_pressed)
	continue_button.pressed.connect(_start_dialogue)

func _start_dialogue():
	# Reestablecemos el botón para el flujo normal
	continue_button.text = "Continuar"
	continue_button.pressed.disconnect(_start_dialogue)
	continue_button.pressed.connect(_on_continue_pressed)
	show_current_dialogue()

func show_transition_screen():
	hide_all_characters()
	dialogue_text.text = "[center][i]Fin Capítulo 1[/i]\nAmor de Madre"
	name_label.text = ""
	continue_button.text = "Siguiente escena"
	continue_button.pressed.disconnect(_on_continue_pressed)
	continue_button.pressed.connect(_on_next_scene)

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

	if is_thought:
		hide_character(right_character)
		show_character(left_character)
		return
	
	if not character_sprites.has(character_name):
		return
	
	var char_side = character_positions.get(character_name, "right")
	var sprite_path = character_sprites[character_name]
	var texture = null
	
	if ResourceLoader.exists(sprite_path):
		texture = load(sprite_path)
	
	if char_side == "left":
		if texture: left_character.texture = texture
		show_character(left_character)
		dim_character(right_character)
	else:
		if texture: right_character.texture = texture
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
	show_transition_screen()

func _on_next_scene():
	Transition.change_scene("res://scenes/main_menu.tscn")
	
func _process(_delta):
	# 2. Monitorear la posición para crear el bucle
	if audio_player and audio_player.playing:
		# Si la canción llega al segundo 10, vuelve al segundo 5
		if audio_player.get_playback_position() >= loop_end:
			audio_player.seek(loop_start)
