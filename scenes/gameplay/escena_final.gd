extends Control

# Referencias a la UI
@onready var dialogue_text = $DialogueContainer/DialogueBox/DialogueText
@onready var name_label = $DialogueContainer/DialogueBox/NameLabel
@onready var continue_button = $DialogueContainer/DialogueBox/ContinueButton

# Referencias a los personajes
@onready var protagonist = $CharacterContainer/Lagrima
@onready var npc_1 = $CharacterContainer/Psicologo
@onready var npc_2 = $CharacterContainer/Mama
@onready var npc_3 = $CharacterContainer/Vecinita

# Referencias de audio
@onready var audio_player = $AudioStreamPlayer 
@onready var sfx_player = $SFXPlayer  # Para efectos de sonido

var current_dialogue_index = 0
var dialogues = []

# Configuración de Audio
var music_loop_start = 3.0
var music_loop_end = 70.0

# Efectos de sonido
var sound_effects = {
	"telefono": "res://assets/musica/telefonoRing.mp3",
	"dialogo": "res://assets/musica/cortoon-voice.mp3"
}

# Sprites de personajes
var character_sprites = {
	"Protagonista": "res://assets/personajes/lagrima.png",
	"Protagonista_Rota": "res://assets/personajes/lagrima.png",
	"Psicólogo": "res://assets/personajes/psicoNoMascara.png",
	"Madre": "res://assets/personajes/madreNoMascara.png",
	"Vecina": "res://assets/personajes/vecainSN.png"
}

# Colores para cada personaje
var character_colors = {
	"Protagonista": Color(1.0, 0.8, 0.6),
	"Emergencias": Color(0.4, 0.8, 0.4),
	"Narrador": Color(0.5, 0.5, 0.5)
}

func _ready():
	if audio_player:
		audio_player.play(music_loop_start)
	
	if sfx_player:
		sfx_player.volume_db = -2
	
	Transition.fade_in()
	
	# Cargar sprites iniciales
	load_character_sprites()
	
	# Estado inicial: Nadie visible
	hide_everybody_instantly()
	
	load_escena_final()
	show_intro_screen()

func _process(_delta):
	if audio_player and audio_player.playing:
		if audio_player.get_playback_position() >= music_loop_end:
			audio_player.seek(music_loop_start)

func load_character_sprites():
	# Cargar sprites para cada personaje
	if ResourceLoader.exists(character_sprites["Protagonista"]):
		protagonist.texture = load(character_sprites["Protagonista"])
	
	if ResourceLoader.exists(character_sprites["Psicólogo"]):
		npc_1.texture = load(character_sprites["Psicólogo"])
	
	if ResourceLoader.exists(character_sprites["Madre"]):
		npc_2.texture = load(character_sprites["Madre"])
	
	if ResourceLoader.exists(character_sprites["Vecina"]):
		npc_3.texture = load(character_sprites["Vecina"])

func load_escena_final():
	dialogues = [
		{"name": "Protagonista", "text": "Odio que me traten así. Como si fuera un pobre perro atropellado.", "state": "solo_ella"},
		{"name": "Protagonista", "text": "¡Ni siquiera les importa cómo me siento!", "state": "solo_ella"},
		{"name": "Protagonista", "text": "Si les importara, no me tratarían así, ocultando lo que son, lo que realmente quieren decir.", "state": "solo_ella"},
		{"name": "Protagonista", "text": "Solo dicen que están para mí para quedar bien... ¡TODOS SON UNOS FALSOS!", "state": "solo_ella"},
		{"name": "Protagonista", "text": "Yo sé, estoy segura, que ninguno de ellos dice lo que en verdad quiere decir...", "state": "solo_ella"},
		{"name": "Protagonista", "text": "...justo como yo.", "state": "solo_ella"},
		{"name": "Protagonista", "text": "...", "state": "solo_ella"},
		{"name": "Protagonista", "text": "¿Por qué no se dan cuenta que miento?", "state": "solo_ella"},
		{"name": "Protagonista", "text": "¿Por qué no se dan cuenta que estoy mal?", "state": "solo_ella"},
		{"name": "Protagonista", "text": "¿Por qué nadie se da cuenta que necesito ayuda?", "state": "solo_ella"},
		{"name": "Protagonista", "text": "...ayuda...", "state": "solo_ella"},
		{"name": "Protagonista", "text": "Ayuda", "state": "solo_ella"},
		{"name": "Protagonista", "text": "AYUDA", "state": "solo_ella"},
		{"name": "Narrador", "text": "[sfx teléfono]", "state": "oscurecer", "sfx": "telefono"},
		{"name": "Emergencias", "text": "Servicio de emergencia mental y psicológica. ¿Está usted en una emergencia y requiere de ayuda inmediata?", "state": "solo_ella"},
		{"name": "Protagonista", "text": "...", "state": "solo_ella"},
		{"name": "Emergencias", "text": "¿Hola?, ¿se equivocó de número?", "state": "solo_ella"},
		{"name": "Protagonista", "text": "... ... hola. Sí... yo... necesito ayuda.", "state": "solo_ella"},
		{"name": "Emergencias", "text": "Hola, me alegra oírte. Claro, con mucho gusto te podemos ayudar; pero antes, ¿hay alguna persona o ser querido que pueda en este momento estar físicamente a tu lado? Eso ayudaría mucho.", "state": "solo_ella"},
		{"name": "Protagonista", "text": "...", "state": "solo_ella"},
		{"name": "Emergencias", "text": "¿No? Claro, no hay problema-", "state": "solo_ella"},
		{"name": "Protagonista", "text": "De hecho, sí, sí lo hay.", "state": "preparar_revelacion"},
		{"name": "Narrador", "text": "[Se oscurece la pantalla...]", "state": "oscurecer_completo"},
		{"name": "Protagonista", "text": "De ellos... ninguno de ellos tenía máscara... siempre fui yo.", "state": "revelacion_final"}
	]
	current_dialogue_index = 0

func show_current_dialogue():
	if current_dialogue_index >= dialogues.size():
		_on_next_scene()
		return
	
	var d = dialogues[current_dialogue_index]
	
	# Aplicar color al nombre según el personaje
	if character_colors.has(d["name"]):
		name_label.add_theme_color_override("font_color", character_colors[d["name"]])
	else:
		name_label.add_theme_color_override("font_color", Color.WHITE)
	
	name_label.text = d["name"]
	dialogue_text.text = d["text"]
	
	# Reproducir efecto de sonido si existe
	if d.has("sfx"):
		play_sound_effect(d["sfx"])
	else:
		# Sonido sutil al hablar (excepto para Narrador y pausas)
		if d["name"] != "Narrador" and d["text"] != "...":
			play_sound_effect("dialogo")
	
	match d["state"]:
		"solo_ella":
			show_only_protagonist()
		"nadie":
			hide_all_characters()
		"oscurecer":
			start_fade_to_black()
		"oscurecer_completo":
			complete_fade_to_black()
		"preparar_revelacion":
			hide_all_characters()
		"revelacion_final":
			show_final_revelation()

func play_sound_effect(effect_name: String):
	if not sfx_player:
		return
	
	if not sound_effects.has(effect_name):
		return
	
	var sfx_path = sound_effects[effect_name]
	
	if ResourceLoader.exists(sfx_path):
		sfx_player.stream = load(sfx_path)
		sfx_player.play()
	else:
		print("SFX no encontrado: " + sfx_path)

func show_only_protagonist():
	# Solo la protagonista visible
	show_node(protagonist)
	hide_node(npc_1)
	hide_node(npc_2)
	hide_node(npc_3)

func start_fade_to_black():
	# Oculta personajes gradualmente
	hide_all_characters()

func complete_fade_to_black():
	# Pantalla completamente oscura
	hide_all_characters()
	name_label.text = ""

func show_final_revelation():
	# 1. Cambiar textura de la protagonista a máscara rota
	if ResourceLoader.exists(character_sprites["Protagonista_Rota"]):
		protagonist.texture = load(character_sprites["Protagonista_Rota"])
	
	# 2. Aparecen todos juntos con un efecto suave y escalonado
	var tween = create_tween()
	
	# Primero la protagonista
	tween.tween_property(protagonist, "modulate:a", 1.0, 1.0)
	
	# Luego los NPCs con un ligero delay
	tween.tween_property(npc_1, "modulate:a", 1.0, 1.5).set_delay(0.5)
	tween.parallel().tween_property(npc_2, "modulate:a", 1.0, 1.5).set_delay(0.7)
	tween.parallel().tween_property(npc_3, "modulate:a", 1.0, 1.5).set_delay(0.9)
	
	# 3. Esperar a que termine la animación
	await tween.finished
	
	# 4. Pequeña pausa dramática antes del texto final
	await get_tree().create_timer(1.0).timeout

# --- Funciones de visibilidad ---

func show_node(node):
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 1.0, 0.5)

func hide_node(node):
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 0.0, 0.5)

func hide_all_characters():
	var tween = create_tween().set_parallel(true)
	tween.tween_property(protagonist, "modulate:a", 0.0, 0.5)
	tween.tween_property(npc_1, "modulate:a", 0.0, 0.5)
	tween.tween_property(npc_2, "modulate:a", 0.0, 0.5)
	tween.tween_property(npc_3, "modulate:a", 0.0, 0.5)

func hide_everybody_instantly():
	protagonist.modulate.a = 0
	npc_1.modulate.a = 0
	npc_2.modulate.a = 0
	npc_3.modulate.a = 0

# --- Lógica de botones ---

func _on_continue_pressed():
	current_dialogue_index += 1
	show_current_dialogue()

func show_intro_screen():
	name_label.text = ""
	dialogue_text.text = "[center][i]CAPÍTULO FINAL[/i]\n\n Sin Máscaras[/center]"
	continue_button.text = "Empezar"
	if not continue_button.pressed.is_connected(_start_dialogue):
		continue_button.pressed.connect(_start_dialogue)

func _start_dialogue():
	continue_button.text = "Continuar"
	continue_button.pressed.disconnect(_start_dialogue)
	continue_button.pressed.connect(_on_continue_pressed)
	show_current_dialogue()

func _on_next_scene():
	# Fade out final
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 2.0)
	await tween.finished
	
	# Ir a créditos
	Transition.change_scene("res://scenes/gameplay/BrokenMask.tscn")
