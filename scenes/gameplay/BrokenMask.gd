extends Node2D

@onready var texture_rect: TextureRect = $TextureRect
@onready var timer: Timer = $Timer
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

var frames: Array[Texture2D] = []
var current_frame := 0

# Fade
var fade_time := 0.4
var end_fade_time := 1.0

# Loop de música
var loop_start := 65.0
var loop_end := 80
var looping := true

func _ready():
	print("READY: cinemática iniciada")

	# --- AUDIO ---
	if audio_player:
		audio_player.play()
		audio_player.seek(loop_start)

	# --- FRAMES ---
	frames = [
		load("res://assets/secuencias/seq1.png"),
		load("res://assets/secuencias/seq2.png"),
		load("res://assets/secuencias/seq3.png"),
		load("res://assets/secuencias/seq4.png"),
		load("res://assets/secuencias/seq5.png"),
		load("res://assets/secuencias/seq6.png"),
	]

	current_frame = 0
	texture_rect.texture = frames[current_frame]
	texture_rect.modulate.a = 1.0

	# --- TIMER ---
	timer.wait_time = 1.0
	timer.one_shot = false
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _process(_delta):
	# Loop musical controlado
	if not looping:
		return

	if audio_player and audio_player.playing:
		if audio_player.get_playback_position() >= loop_end:
			audio_player.seek(loop_start)

func _on_timer_timeout():
	current_frame += 1
	print("CAMBIO A FRAME:", current_frame)

	if current_frame >= frames.size():
		timer.stop()
		looping = false
		_fade_out_and_go_to_credits()
		return

	_fade_to_next_frame()

func _fade_to_next_frame():
	var tween_out := create_tween()
	tween_out.tween_property(texture_rect, "modulate:a", 0.0, fade_time)

	tween_out.finished.connect(func ():
		texture_rect.texture = frames[current_frame]

		var tween_in := create_tween()
		tween_in.tween_property(texture_rect, "modulate:a", 1.0, fade_time)
	)

func _fade_out_and_go_to_credits():
	print("FADE FINAL")

	var tween := create_tween()
	tween.tween_property(texture_rect, "modulate:a", 0.0, end_fade_time)

	tween.finished.connect(func ():
		get_tree().change_scene_to_file("res://scenes/gameplay/credits.tscn")
	)
