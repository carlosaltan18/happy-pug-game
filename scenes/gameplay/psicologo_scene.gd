extends Control

# Referencias a los nodos de la UI
@onready var dialogue_text = $DialogueContainer/DialogueBox/DialogueText
@onready var name_label = $DialogueContainer/DialogueBox/NameLabel
@onready var continue_button = $DialogueContainer/DialogueBox/ContinueButton

# Referencias a los personajes
@onready var left_character = $CharacterContainer/Lagrima
@onready var right_character = $CharacterContainer/Psicologo

@onready var audio_player = $AudioStreamPlayer 

# Variables del sistema de diálogos
var current_dialogue_index = 0
var dialogues = []

# Variables de control de audio (Inicia en 5s y loopea hasta los 10s)
var music_loop_start = 3.0
var music_loop_end = 29.0

# Colores para cada personaje
var character_colors = {
	"Protagonista": Color(1.0, 0.8, 0.6),
	"Psicólogo": Color(0.6, 0.8, 1.0), # Color azul profesional
	"Narrador": Color(0.5, 0.5, 0.5),
	"Pensamiento": Color(0.7, 0.7, 1.0)
}

# Sprites de personajes
var character_sprites = {
	"Protagonista": "res://assets/personajes/lagrima.png",
	"Psicólogo": "res://assets/personajes/psico.png" # Asegúrate de que esta ruta sea correcta
}

# Posiciones de personajes
var character_positions = {
	"Protagonista": "left",
	"Psicólogo": "right"
}

func _ready():
	# Iniciar audio en el segundo inicial del bucle
	if audio_player:
		audio_player.play(music_loop_start)
		
	Transition.fade_in()
	continue_button.pressed.connect(_on_continue_pressed)
	
	# Estado inicial invisible
	left_character.modulate.a = 0
	right_character.modulate.a = 0
	
	load_escena_psicologo()
	show_intro_screen()

func _process(_delta):
	# Gestión del Loop de música (5s a 10s)
	if audio_player and audio_player.playing:
		if audio_player.get_playback_position() >= music_loop_end:
			audio_player.seek(music_loop_start)

func load_escena_psicologo():
	dialogues = [
		{"character": "Psicólogo", "text": "Dime... ¿cómo te has sentido desde nuestra última sesión?", "is_thought": false},
		{"character": "Protagonista", "text": "Igual. El silencio en la casa sigue siendo demasiado ruidoso.", "is_thought": false},
		{"character": "Psicólogo", "text": "Es normal buscar culpables cuando no entendemos el porqué de una pérdida.", "is_thought": false},
		{"character": "Protagonista", "text": "No busco culpables. Solo quiero que el tiempo se detenga.", "is_thought": false},
		{"character": "Protagonista", "text": "[i]¿Realmente cree que hablar de esto va a cambiar algo?[/i]", "is_thought": true},
		{"character": "Protagonista", "text": "[i]Solo está sentado ahí, tomando notas, mientras mi mundo se cae a pedazos.[/i]", "is_thought": true},
		{"character": "Psicólogo", "text": "La aceptación es un proceso lento. No te presiones.", "is_thought": false},
		{"character": "Protagonista", "text": "[i]Aceptación... qué palabra tan vacía.[/i]", "is_thought": true},
		{"character": "Narrador", "text": "[El reloj de la pared marca cada segundo con fuerza]", "is_thought": false}
	]
	current_dialogue_index = 0

# --- PANTALLAS DE TÍTULO ---

func show_intro_screen():
	name_label.text = ""
	dialogue_text.text = "[center][i]Capítulo 3[/i]\nEl Peso de las Palabras"
	continue_button.text = "Empezar"
	if continue_button.pressed.is_connected(_on_continue_pressed):
		continue_button.pressed.disconnect(_on_continue_pressed)
	continue_button.pressed.connect(_start_dialogue)

func _start_dialogue():
	continue_button.text = "Continuar"
	continue_button.pressed.disconnect(_start_dialogue)
	continue_button.pressed.connect(_on_continue_pressed)
	show_current_dialogue()

func show_transition_screen():
	hide_all_characters()
	dialogue_text.text = "[center][i]Fin de la Sesión[/i]\nMáscaras de Duelo"
	name_label.text = ""
	continue_button.text = "Continuar"
	continue_button.pressed.disconnect(_on_continue_pressed)
	continue_button.pressed.connect(_on_next_scene)

# --- LÓGICA DE DIÁLOGO ---

func show_current_dialogue():
	if current_dialogue_index >= dialogues.size():
		end_escena()
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

	# Lógica de Pensamiento: La protagonista se queda sola
	if is_thought:
		hide_character(right_character) # Oculta al Psicólogo
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

func end_escena():
	show_transition_screen()

func _on_next_scene():
	Transition.change_scene("res://scenes/main_menu.tscn")
