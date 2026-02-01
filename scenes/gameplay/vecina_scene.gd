extends Control

# Referencias a los nodos de la UI
@onready var dialogue_text = $DialogueContainer/DialogueBox/DialogueText
@onready var name_label = $DialogueContainer/DialogueBox/NameLabel
@onready var continue_button = $DialogueContainer/DialogueBox/ContinueButton

# Referencias a los personajes
@onready var left_character = $CharacterContainer/Lagrima
@onready var right_character = $CharacterContainer/Vecina

@onready var audio_player = $AudioStreamPlayer 

# Variables del sistema de diálogos
var current_dialogue_index = 0
var dialogues = []

# Configuración de Audio
var music_loop_start = 0.0
var music_loop_end = 45.0 

# Colores para cada personaje
var character_colors = {
	"Protagonista": Color(1.0, 0.8, 0.6),
	"Vecina": Color(0.6, 1.0, 0.8),
	"Narrador": Color(0.5, 0.5, 0.5),
	"Pensamiento": Color(0.7, 0.7, 1.0)
}

# Rutas de Sprites (Asegúrate de que estas rutas sean 100% correctas)
var character_sprites = {
	"Protagonista": "res://assets/personajes/lagrima.png",
	"Vecina": "res://assets/personajes/vecina.png"
}

func _ready():
	if audio_player:
		audio_player.play(music_loop_start)
		
	Transition.fade_in()
	
	# 1. Cargamos directamente. Si la ruta está mal, Godot avisará.
	# Si la ruta es correcta, load() funcionará siempre en el exportado.
	left_character.texture = load(character_sprites["Protagonista"])
	right_character.texture = load(character_sprites["Vecina"])
	
	# 2. Forzamos la opacidad a 0 al inicio (como ya tenías)
	left_character.modulate.a = 0
	right_character.modulate.a = 0
	
	load_escena_vecina()
	show_intro_screen()

func _process(_delta):
	if audio_player and audio_player.playing:
		if audio_player.get_playback_position() >= music_loop_end:
			audio_player.seek(music_loop_start)

func load_escena_vecina():
	dialogues = [
	{"character": "Narrador", "text": "Otra vez en mi torre de apartamentos.\nTe recuerdo correr por los pasillos… y ahora ya no estás.", "is_thought": false},
	{"character": "Vecina", "text": "Hola, cariño. ¿Cómo estás?", "is_thought": false},
	{"character": "Protagonista", "text": "Pues, ahí voy.", "is_thought": false},
	{"character": "Vecina", "text": "Entiendo tu dolor, créeme.\nPerder a alguien es sumamente difícil.", "is_thought": false},
	{"character": "Protagonista", "text": "Conozco a la vecina desde hace años, el único ser querido que ha perdido es su loro hace unos 4 años.\nEl loro vivió 20 años… mucho más que mi hijo.", "is_thought": true},
	{"character": "Vecina", "text": "Pues sí, cariño, ¿necesitas ayuda en algo?", "is_thought": false},
	{"character": "Protagonista", "text": "La vecina, siempre metiéndose en cosas que no le incumben.\nNo importa qué fuera, siempre preguntaba qué estábamos haciendo; ¿qué le importa?\nAl menos su hijo era buen amigo del mío.", "is_thought": true},
	{"character": "Protagonista", "text": "No, gracias. Estoy bien.\nNo necesito nada.", "is_thought": false},
	{"character": "Vecina", "text": "¡Qué bien que estás bien! Hasta acá puedo sentir tus buenas vibras,\n¿sabes que según tus vibras eso atraes?", "is_thought": false},
	{"character": "Vecina", "text": "Por ejemplo, si tienes buenas vibras, atraes cosas buenas;\nsi no, atraes cosas malas. ¡Me encanta esa forma de pensar!", "is_thought": false},
	{"character": "Protagonista", "text": "Entonces según tú, ¿mi hijo tenía tantas “malas vibras”\nque por eso le pasó lo que le pasó?", "is_thought": false},
	{"character": "Vecina", "text": "Ay, ¡vamos! No te pongas así, sabes que yo no quería decir eso.\nAgradece que te estoy intentando animar.", "is_thought": false},
	{"character": "Protagonista", "text": "Ni loca voy a agradecer tu lástima.", "is_thought": true},
	{"character": "Vecina", "text": "En fin, te quería decir que hoy iba a cocinar un pastel de ciruelas con flan de cajeta.\n¡Si quieres ven y entra!", "is_thought": false},
	{"character": "Protagonista", "text": "¿Quién siquiera quisiera comer pastel en esta situación?", "is_thought": true},
	{"character": "Protagonista", "text": "Creo que paso, gracias.", "is_thought": false},
	{"character": "Vecina", "text": "Como sea, no digas que no lo intenté.", "is_thought": false},
	{"character": "Vecina", "text": "Por cierto, te quería decir algo. ¡Ve el lado positivo en esto! No estás sola.\nNosotros también estamos sintiendo tu mismo dolor,\nmi pequeño Josh perdió a su mejor amigo. Compartimos tu luto.", "is_thought": false},
	{"character": "Protagonista", "text": "Claro… porque que se muera el amigo de tu hijo\ntiene el mismo grado que se muera tu hijo.", "is_thought": true},
	{"character": "Protagonista", "text": "Si me disculpas, tengo que volver a mi apartamento.\nTengo mi primera terapia.", "is_thought": false},
	{"character": "Vecina", "text": "Esas son buenas noticias, ¡me alegro por ti! Ya sabes que siempre estoy aquí al lado para lo que sea que necesites.", "is_thought": false},
	{"character": "Protagonista", "text": "Yo no.", "is_thought": true}
]

# --- FLUJO DE PANTALLAS ---

func show_intro_screen():
	name_label.text = ""
	dialogue_text.text = "[center][i]Capítulo 2[/i]\nEl 'Luto' de la Vecina"
	continue_button.text = "Empezar"
	# Desconectar cualquier señal previa para evitar clics dobles
	if continue_button.pressed.is_connected(_on_continue_pressed):
		continue_button.pressed.disconnect(_on_continue_pressed)
	if continue_button.pressed.is_connected(_start_dialogue):
		continue_button.pressed.disconnect(_start_dialogue)
	
	continue_button.pressed.connect(_start_dialogue)

func _start_dialogue():
	continue_button.text = "Continuar"
	continue_button.pressed.disconnect(_start_dialogue)
	continue_button.pressed.connect(_on_continue_pressed)
	show_current_dialogue()

func show_current_dialogue():
	if current_dialogue_index >= dialogues.size():
		end_escena()
		return
	
	var current = dialogues[current_dialogue_index]
	update_character_visuals(current["character"], current["is_thought"])
	
	# Configurar el texto y nombre
	if current["character"] == "Narrador":
		name_label.text = ""
		dialogue_text.text = "[center][i]" + current["text"] + "[/i][/center]"
	else:
		if current["is_thought"]:
			name_label.text = current["character"] + " (pensando)"
			name_label.add_theme_color_override("font_color", character_colors["Pensamiento"])
		else:
			name_label.text = current["character"]
			name_label.add_theme_color_override("font_color", character_colors.get(current["character"], Color.WHITE))
		
		dialogue_text.text = current["text"]

func _on_continue_pressed():
	current_dialogue_index += 1
	show_current_dialogue()

# --- LÓGICA VISUAL ---

func update_character_visuals(character_name: String, is_thought: bool):
	if character_name == "Narrador":
		hide_all_characters()
		return

	if is_thought:
		# En pensamientos solo se ve a la protagonista iluminada
		show_character(left_character)
		hide_character(right_character)
	else:
		if character_name == "Protagonista":
			show_character(left_character)
			dim_character(right_character)
		elif character_name == "Vecina":
			show_character(right_character)
			dim_character(left_character)

func show_character(node: TextureRect):
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 1.0, 0.3)

func dim_character(node: TextureRect):
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 0.4, 0.3)

func hide_character(node: TextureRect):
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 0.0, 0.3)

func hide_all_characters():
	hide_character(left_character)
	hide_character(right_character)

# --- FINALIZACIÓN ---

func end_escena():
	hide_all_characters()
	dialogue_text.text = "[center][i]Fin del encuentro[/i]\nCaminos de Pasillo"
	name_label.text = ""
	continue_button.text = "Siguiente"
	continue_button.pressed.disconnect(_on_continue_pressed)
	continue_button.pressed.connect(_on_next_scene)

func _on_next_scene():
	Transition.change_scene("res://scenes/gameplay/psicologo_scene.tscn")
