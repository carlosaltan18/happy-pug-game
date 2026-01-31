extends Control

# Referencias a los botones
@onready var new_game_button = $MenuContainer/SpacerTop/ButtonsContainer/Start
@onready var exit_button = $MenuContainer/SpacerTop/ButtonsContainer/Exit
@onready var credits_button = $MenuContainer/SpacerTop/ButtonsContainer/Credits

func _ready():
	Transition.fade_in()
	
	# Conectar las señales de los botones
	new_game_button.pressed.connect(_on_new_game_pressed)
	exit_button.pressed.connect(_on_quit_pressed)
	credits_button.pressed.connect(_on_credits_pressed)
	
func _on_new_game_pressed():
	print("Iniciando nuevo juego...")
	get_tree().change_scene_to_file("res://scenes/gameplay/main_game.tscn")

	# Aquí cambiarás a la escena del juego

func _on_credits_pressed():
	print("Abriendo Creditos...")
	# Aquí abrirás el menú de configuración

func _on_quit_pressed():
	print("Saliendo del juego...")
	get_tree().quit()
