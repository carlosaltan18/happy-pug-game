extends Control

# Referencias a los nodos de la UI
@onready var dialogue_text = $DialogueContainer/DialogueBox/DialogueText
@onready var name_label = $DialogueContainer/DialogueBox/NameLabel
@onready var continue_button = $DialogueContainer/DialogueBox/ContinueButton

# Referencias a los personajes
@onready var left_character = $CharacterContainer/Lagrima
@onready var right_character = $CharacterContainer/PersonajeNpc

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

# Sprites de personajes (ruta a las imágenes)
var character_sprites = {
	"Protagonista": "res://assets/personajes/lagrima.png",
	"Desconocida": "res://assets/personajes/npc.png"
}

# Posiciones de personajes (quién va a la izquierda o derecha)
var character_positions = {
	"Protagonista": "left",      # Protagonista a la izquierda
	"Desconocida": "right"        # Desconocida a la derecha
}

func _ready():
	continue_button.pressed.connect(_on_continue_pressed)
	print("Prólogo cargado")
	
	# Ocultar personajes al inicio
	left_character.modulate.a = 0
	right_character.modulate.a = 0
	
	load_prologo()
	show_current_dialogue()

func load_prologo():
	dialogues = [
		{"character": "Desconocida", "text": "Querida, lamento mucho la pérdida de tu hijo. Era un niño tan dulce.", "is_thought": false},
		{"character": "Protagonista", "text": "Gracias.", "is_thought": false},
		{"character": "Desconocida", "text": "Si hay algo que podamos hacer para mejorar la situación, no dude en decirnos.", "is_thought": false},
		{"character": "Protagonista", "text": "...Claro.", "is_thought": false},
		{"character": "Narrador", "text": "[Se va]", "is_thought": false},
		{"character": "Protagonista", "text": "[i]Esos fueron los últimos en irse.[/i]", "is_thought": false},
		{"character": "Protagonista", "text": "[i]Todas estas personas tan falsas... me dan asco.[/i]", "is_thought": false},
		{"character": "Protagonista", "text": "[i]Detesto la forma en la que me miran, cómo me juzgan: \"ella es la pobre madre que está enterrando a su hijo\".[/i]", "is_thought": true},
		{"character": "Protagonista", "text": "[i]La mitad ni siquiera lo conocían.[/i]", "is_thought": false},
		{"character": "Protagonista", "text": "[i]...[/i]", "is_thought": false},
		{"character": "Protagonista", "text": "[i]Debo ir a visitar a mi madre, no me he sentido bien.[/i]", "is_thought": false}
	]
	current_dialogue_index = 0

func show_current_dialogue():
	if current_dialogue_index >= dialogues.size():
		end_prologo()
		return
	var current = dialogues[current_dialogue_index]
	show_dialogue(current["character"], current["text"], current["is_thought"])

func show_dialogue(character_name: String, text: String, is_thought: bool = false):
	# Actualizar sprites de personajes
	update_character_sprites(character_name, is_thought)
	
	# Manejo especial para narraciones
	if character_name == "Narrador":
		name_label.text = ""
		dialogue_text.text = "[center][i]" + text + "[/i][/center]"
		hide_all_characters()
		return
	
	# Configurar nombre y color
	if is_thought:
		name_label.text = character_name + " (pensando)"
		name_label.add_theme_color_override("font_color", character_colors["Pensamiento"])
	else:
		name_label.text = character_name
		if character_colors.has(character_name):
			name_label.add_theme_color_override("font_color", character_colors[character_name])
		else:
			name_label.add_theme_color_override("font_color", Color.WHITE)
	
	dialogue_text.text = text

func update_character_sprites(character_name: String, is_thought: bool):
	# Si es pensamiento o narrador, no mostrar cambios de personaje
	if is_thought or character_name == "Narrador":
		return
	
	# Verificar si el personaje tiene sprite
	if not character_sprites.has(character_name):
		return
	
	# Obtener posición del personaje
	var position = character_positions.get(character_name, "right")
	
	# Cargar la imagen
	var sprite_path = character_sprites[character_name]
	var texture = null
	if ResourceLoader.exists(sprite_path):
		texture = load(sprite_path)
	
	if position == "left":
		# Mostrar en la izquierda
		if texture:
			left_character.texture = texture
		show_character(left_character)
		dim_character(right_character)
	else:
		# Mostrar en la derecha
		if texture:
			right_character.texture = texture
		show_character(right_character)
		dim_character(left_character)

func show_character(character_node: TextureRect):
	# Mostrar personaje con fade in suave
	var tween = create_tween()
	tween.tween_property(character_node, "modulate:a", 1.0, 0.3)

func dim_character(character_node: TextureRect):
	# Atenuar personaje (no habla)
	var tween = create_tween()
	tween.tween_property(character_node, "modulate:a", 0.5, 0.3)

func hide_character(character_node: TextureRect):
	# Ocultar personaje con fade out
	var tween = create_tween()
	tween.tween_property(character_node, "modulate:a", 0.0, 0.3)

func hide_all_characters():
	# Ocultar todos los personajes
	hide_character(left_character)
	hide_character(right_character)

func _on_continue_pressed():
	print("Botón continuar presionado - Diálogo: " + str(current_dialogue_index))
	current_dialogue_index += 1
	show_current_dialogue()

func end_prologo():
	print("Prólogo completado")
	hide_all_characters()
	show_transition_screen()

func show_transition_screen():
	dialogue_text.text = "[center][i]Fin del prólogo[/i]\nMáscaras de Duelo"
	name_label.text = ""
	continue_button.text = "Siguiente escena"
	continue_button.pressed.disconnect(_on_continue_pressed)
	continue_button.pressed.connect(_on_next_scene)

func _on_next_scene():
	Transition.change_scene("res://scenes/main_menu.tscn")
	
