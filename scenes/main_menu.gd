extends Control

@onready var new_game_button = $MenuContainer/SpacerTop/ButtonsContainer/Start
@onready var exit_button = $MenuContainer/SpacerTop/ButtonsContainer/Exit
@onready var credits_button = $MenuContainer/SpacerTop/ButtonsContainer/Credits
@onready var audio_player = $AudioStreamPlayer

var loop_start = 3.0
var loop_end = 41.0
func _ready():
	
	if audio_player:
			audio_player.play(loop_start)
	Transition.fade_in()
	
	new_game_button.pressed.connect(_on_new_game_pressed)
	exit_button.pressed.connect(_on_quit_pressed)
	credits_button.pressed.connect(_on_credits_pressed)
	
func _on_new_game_pressed():
	print("Iniciando nuevo juego...")
	get_tree().change_scene_to_file("res://scenes/gameplay/main_game.tscn")


func _on_credits_pressed():
	print("Abriendo Creditos...")
	get_tree().change_scene_to_file("res://scenes/gameplay/credits.tscn")


func _on_quit_pressed():
	print("Saliendo del juego...")
	get_tree().quit()
func _process(_delta):
	if audio_player and audio_player.playing:
		if audio_player.get_playback_position() >= loop_end:
			audio_player.seek(loop_start)
