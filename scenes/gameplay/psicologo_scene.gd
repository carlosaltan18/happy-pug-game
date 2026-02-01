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
		{"character": "Protagonista", "text": "Cuando entré a mi apartamento, ya estaba ahí el psicólogo. Tal parece, mi mamá le dio sus llaves de repuesto.", "is_thought": true},
		{"character": "Psicólogo", "text": "Hola, mi nombre es Boid. Seré tu psicólogo de aquí en adelante.", "is_thought": false},
		{"character": "Protagonista", "text": "Claro. ", "is_thought": false},
		{"character": "Psicólogo", "text": "¿Cómo te sientes el día de hoy?", "is_thought": false},
		{"character": "Protagonista", "text": "¿Usted cómo cree que me siento?", "is_thought": false},
		{"character": "Psicólogo", "text": "Pues por eso le pregunto, ¿qué siente?", "is_thought": false},
		{"character": "Protagonista", "text": "Yo conozco estos trucos, te engañan para decir algo con tal de ellos no quedar mal.", "is_thought": true},
		{"character": "Protagonista", "text": "No voy a responder eso. Yo no pedí esta ayuda, no la necesito. ", "is_thought": false},
		{"character": "Psicólogo", "text": "La negación es parte del proceso. Lo primero que tiene que saber, es que nada de lo que pasó fue su culpa, fue un accidente donde usted ni siquiera estaba cerca o podía hacer algo. Todo lo que dice es demasiado cálido para ser real, y demasiado frío para ser empático.", "is_thought": false},
	{"character": "Protagonista", "text": "No me diga lo que ya sé. Igual, lo que me pasó no tiene solución.", "is_thought": false},
		{"character": "Psicólogo", "text": "Créame que, con la metodología correcta, todo tiene solución. ", "is_thought": false},
		{"character": "Protagonista", "text": "Posiblemente, solo siente pena por mí. Pena y hambre, porque se está llevando nuestro dinero como parásito…  ", "is_thought": true},
		{"character": "Protagonista", "text": "aunque sin él, ya no hay en qué gastarlo, ¿verdad? …", "is_thought": true},
		{"character": "Psicólogo", "text": "Empezaré la sesión, si así le parece. Es normal que luego de momentos así de traumáticos, existan sentimientos de culpa, ¿ha sentido alguno en la última semana?", "is_thought": false},
		{"character": "Protagonista", "text": "No.", "is_thought": false},
		{"character": "Psicólogo", "text": "Claro, continuemos.  ¿Ha sentido disminución en su apetito? ", "is_thought": false},
		{"character": "Protagonista", "text": "No.", "is_thought": false},
		{"character": "Psicólogo", "text": "¿Ha sentido que las cosas alrededor suyo no son reales?, o ¿ha notado distintas a las personas que le rodean? ¿sus rostros?", "is_thought": false},
	{"character": "Protagonista", "text": "¿Me está tomando el pelo?", "is_thought": false},
		{"character": "Psicólogo", "text": "Absolutamente no. Pero debido a la seriedad del trauma, puede que haya desarrollado algún tipo de trastorno y requiera de mayor ayuda.", "is_thought": false},
		{"character": "Protagonista", "text": "Ya he dicho que yo NO necesito ayuda. ", "is_thought": false},
		{"character": "Psicólogo", "text": "Claro… trabajaremos en eso. ¿Cómo se siente en este momento?, ¿sintió mucha presión de estas preguntas?, ¿algún sentimiento encontrado?", "is_thought": false},
		{"character": "Protagonista", "text": "Una parte de mí quiere llorar, pero otra no la deja…", "is_thought": true},
	{"character": "Protagonista", "text": "Bueno, creo que sí llegué a sentir que...", "is_thought": false},
		{"character": "Psicólogo", "text": "Ya se acabó el tiempo, una hora de sesión. Ahora debo de atender a alguien más, ¿le parece bien si quedamos la otra semana a la misma hora?", "is_thought": false},
		{"character": "Protagonista", "text": "Justo como todos, solo lo hace para quedar bien.", "is_thought": false},
		{"character": "Protagonista", "text": "Lo que sea.", "is_thought": false},
		{"character": "Psicólogo", "text": "Mire, le dejo este número por si tiene alguna emergencia emocional. Además, le doy mi propio número, por si me necesita; llegaré lo antes posible. ", "is_thought": false},
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
	Transition.change_scene("res://scenes/gameplay/escena_final.tscn")
