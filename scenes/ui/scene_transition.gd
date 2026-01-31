extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var animation_player = $ColorRect/AnimationPlayer
func _ready():
	# Hacer la transición invisible al inicio
	color_rect.modulate.a = 0

# Fade a negro y luego cambia de escena
func change_scene(scene_path: String):
	# Fade out (pantalla a negro)
	animation_player.play("fade_out")
	await animation_player.animation_finished
	
	# Cambiar escena
	get_tree().change_scene_to_file(scene_path)
	
	# Fade in (negro a transparente)
	animation_player.play("fade_in")

# Solo fade out
func fade_out():
	color_rect.show() # Lo hacemos visible antes de la animación
	animation_player.play("fade_out")
	await animation_player.animation_finished

func fade_in():
	animation_player.play_backwards("fade_out") # O "fade_in" si creaste una nueva
	await animation_player.animation_finished
	color_rect.hide() # Lo ocultamos al terminar para que no bloquee los clics
