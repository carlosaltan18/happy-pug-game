extends Control

@onready var credits_text = $ScrollContainer/CreditsText
@onready var skip_button = $SkipButton
@onready var background = $Background
@onready var audio_player = $AudioStreamPlayer 

var music_loop_start = 3.0
var music_loop_end = 50.0
# Velocidad de scroll (píxeles por segundo)
var scroll_speed = 50.0

# Posición inicial y final
var start_y = 1080.0  # Empieza abajo de la pantalla
var end_y = -3000.0   # Termina arriba de la pantalla (fuera de vista)

# Variable de tiempo
var is_scrolling = false

func _ready():
	if audio_player:
			audio_player.play(music_loop_start)	
	# Fade in
	background.modulate.a = 0
	var tween = create_tween()
	tween.tween_property(background, "modulate:a", 1.0, 1.0)
	
	# Conectar botón de saltar
	skip_button.pressed.connect(_on_skip_pressed)
	
	# Cargar el texto de los créditos
	load_credits_text()
	
	# Esperar 2 segundos y empezar scroll
	await get_tree().create_timer(2.0).timeout
	start_scroll()

func load_credits_text():
	# Asegúrate de que credits_text sea un RichTextLabel para que el BBCode funcione
	credits_text.bbcode_enabled = true 
	
	credits_text.text = """
[center][font_size=72][b]MÁSCARAS DE DUELO[/b][/font_size]

[font_size=28][i]A story by Happy Pug Games[/i][/font_size]


[font_size=50][b]CRÉDITOS[/b][/font_size]


[font_size=42][b]EQUIPO DE DESARROLLO[/b][/font_size]

[font_size=36]Director del Proyecto
[b]Mateo "Pug Master" Rossi[/b][/font_size]

[font_size=36]Guión y Narrativa
[b]Elena Valeriano[/b][/font_size]

[font_size=36]Programación
[b]Julián Scriptman[/b][/font_size]

[font_size=36]Diseño de UI/UX
[b]Sofía Pixel-Perfect[/b][/font_size]


[font_size=42][b]ARTE[/b][/font_size]

[font_size=36]Ilustraciones de Personajes
[b]Lucía Trazo[/b]

Fondos y Escenarios
[b]Carlos Horizonte[/b][/font_size]


[font_size=42][b]AUDIO[/b][/font_size]

[font_size=36]Composición Musical
[b]Damián Melodía[/b]

Diseño de Sonido
[b]Foley Wizard[/b][/font_size]


[font_size=42][b]CONTROL DE CALIDAD[/b][/font_size]

[font_size=36]Beta Testers
Juan "BugHunter" Pérez
Ana Demo-Player
Lucas Glitch-Finder[/font_size]


[font_size=42][b]AGRADECIMIENTOS ESPECIALES[/b][/font_size]

[font_size=32][i]A nuestra familia por su apoyo incondicional
A la comunidad de Godot por sus recursos
A todos los que inspiraron esta historia[/i][/font_size]


[font_size=50][b]DESARROLLADO CON[/b][/font_size]

[font_size=36]Godot Engine 4.x
GDScript[/font_size]


[font_size=42][b]DEDICATORIA[/b][/font_size]

[font_size=32][i]Para todas las personas que enfrentan el duelo
y buscan encontrar esperanza en la oscuridad[/i][/font_size]




[font_size=80][b]GRACIAS POR JUGAR[/b][/font_size]


[font_size=28]© 2026 Happy Pug Games
Todos los derechos reservados[/font_size]




[font_size=40][i]~ Fin ~[/i][/font_size]
[/center]
"""

func start_scroll():
	is_scrolling = true
	
	# Calcular duración basada en la distancia y velocidad
	var distance = start_y - end_y
	var duration = distance / scroll_speed
	
	# Crear tween para el scroll
	var tween = create_tween()
	tween.tween_property(credits_text, "position:y", end_y, duration)
	tween.tween_callback(_on_credits_finished)

func _on_credits_finished():
	print("Créditos terminados")
	# Esperar 2 segundos
	await get_tree().create_timer(2.0).timeout
	# Volver al menú
	return_to_menu()

func _on_skip_pressed():
	print("Créditos saltados")
	return_to_menu()

func return_to_menu():
	# Fade out
	var tween = create_tween()
	tween.tween_property(background, "modulate:a", 0.0, 1.0)
	await tween.finished
	
	# Cambiar al menú
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _process(delta):
	# Permitir saltar con ESC o SPACE
	if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("ui_accept"):
		if is_scrolling:
			_on_skip_pressed()
	if audio_player and audio_player.playing:
		# Si la canción llega al segundo 10, vuelve al segundo 5
		if audio_player.get_playback_position() >= music_loop_end:
			audio_player.seek(music_loop_start)
			
