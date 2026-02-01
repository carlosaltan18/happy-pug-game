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
	{"character": "Narrador", "text": "Ya pasó una semana… Siento como si hubiera sido hace un momento,\nhace un instante… Hace un instante estabas conmigo…", "is_thought": false},
	{"character": "Narrador", "text": "Mi madre dijo que quería hablar conmigo,\nasí que fui a su casa.", "is_thought": false},
	{"character": "Mamá", "text": "¡Hija! Cielo,\n¿cómo estás?", "is_thought": false},
	{"character": "Protagonista", "text": "Sigo viva.", "is_thought": false},
	{"character": "Mamá", "text": "¿Estás comiendo bien?", "is_thought": false},
	{"character": "Protagonista", "text": "Sí, mamá. Igual que cuando era niña,\ncomiendo solo 2 veces por semana.", "is_thought": true},
	{"character": "Protagonista", "text": "Sí.", "is_thought": false},
	{"character": "Mamá", "text": "¿Has conseguido dormir?\n¿Cómo te va con eso?", "is_thought": false},
	{"character": "Protagonista", "text": "Pues… cada vez que lo intento, por un momento está bien;\npero luego vienen las pesadillas, y ya no puedo conciliar el sueño.", "is_thought": false},
	{"character": "Mamá", "text": "Oh, lo siento tanto cielo. Aún recuerdo las pesadillas\nque me contabas cuando eras una niña apenas...", "is_thought": false},
	{"character": "Mamá", "text": "Tú sabes que la vida es un momento, mira por ejemplo mi amiga Julia,\nen un día comíamos un pie, y al día siguiente ya había muerto.", "is_thought": false},
	{"character": "Protagonista", "text": "Julia tenía 77 años. Además, ya estaba enferma de hace años.\nPero cada vez que le menciono eso a mi mamá, se enoja.", "is_thought": true},
	{"character": "Protagonista", "text": "Mamá, ¿podemos no hablar de esto?", "is_thought": false},
	{"character": "Mamá", "text": "Está bien, hija.\nPor cierto, tu hermano llamó. Me hizo tan feliz.", "is_thought": false},
	{"character": "Protagonista", "text": "¿Dijo por qué no llegó al velorio?", "is_thought": false},
	{"character": "Mamá", "text": "¡Hija! Ya sabes que tu hermano trabaja mucho,\nademás vive en otro país, ¡no puede viajar así como si nada!", "is_thought": false},
	{"character": "Protagonista", "text": "Tú sabes que sí lo ha hecho ya en otras veces.", "is_thought": false},
	{"character": "Mamá", "text": "Pero por el cumpleaños de su suegra.\nSuegra solo hay una en la vida.", "is_thought": false},
	{"character": "Protagonista", "text": "También era su único sobrino…", "is_thought": false},
	{"character": "Mamá", "text": "Bueno, qué importa ya. Llamó porque dice qué te quiere pagar un psicólogo.\nDicen que esas cosas ayudan.", "is_thought": false},
	{"character": "Protagonista", "text": "No gracias, mamá. Estoy bien.\nNo necesito eso.", "is_thought": false},
	{"character": "Mamá", "text": "Tú sabes que yo tampoco creo en eso hija,\npero tal vez algo te puede ayudar.", "is_thought": false},
	{"character": "Protagonista", "text": "¡Mamá! Esto no es como ir a un doctor; no me pueden dar una medicina...\nEsta sensación, este sufrimiento, no sé si me lo pueda arrancar algún día…", "is_thought": false},
	{"character": "Mamá", "text": "Lo siento tanto, hija. Supongo que es cierto, vivir más que un hijo…\nqué tragedia. No puedo ni siquiera pensar cómo estaría yo si tu hermano o tú…", "is_thought": false},
	{"character": "Mamá", "text": "Oh, lo siento. No quería.", "is_thought": false},
	{"character": "Protagonista", "text": "Nunca quieres mamá,\npero siempre lo haces.", "is_thought": true},
	{"character": "Mamá", "text": "En fin, lo que te quería decir: hoy empiezan tus terapias.\nEl psicólogo llegará hoy a tu apartamento.", "is_thought": false},
	{"character": "Protagonista", "text": "¡¿Qué?! ¡Ni siquiera me preguntaste!", "is_thought": false},
	{"character": "Mamá", "text": "Llevabas una semana sin salir de tu casa, ¡ya me había preocupado!\nAhora ya vete, que llegarás tarde con él.", "is_thought": false},
	{"character": "Mamá", "text": "Una buena señorita nunca puede quedar mal.\nY si necesitas algo, solo llámame, llegaré enseguida.", "is_thought": false},
	{"character": "Protagonista", "text": "Como siempre, mamá…\nDecidiendo por mí.", "is_thought": true},
	{"character": "Protagonista", "text": "Mi mamá nunca fue tan cercana a mí.\nPasaba tanto tiempo en el trabajo que apenas si lo compartía con nosotros…", "is_thought": true},
	{"character": "Protagonista", "text": "Yo quise estar más para mi hijo, pero…\nahora solo ya no está.", "is_thought": true}
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
	Transition.change_scene("res://scenes/gameplay/vecina-scene.tscn")
	
func _process(_delta):
	# 2. Monitorear la posición para crear el bucle
	if audio_player and audio_player.playing:
		# Si la canción llega al segundo 10, vuelve al segundo 5
		if audio_player.get_playback_position() >= loop_end:
			audio_player.seek(loop_start)
