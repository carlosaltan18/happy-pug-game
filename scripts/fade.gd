extends CanvasLayer

@onready var fade_rect: ColorRect = $ColorRect
@onready var door_sfx: AudioStreamPlayer = $SFXDoor

@export var fade_time: float = 0.5

func fade_out():
	door_sfx.play()
	await get_tree().create_timer(0.1).timeout
	#tween is for smooth animations
	var tween = get_tree().create_tween()
	tween.tween_property(fade_rect, "color:a", 1.0, fade_time)
	await tween.finished

func fade_in():
	var tween = get_tree().create_tween()
	tween.tween_property(fade_rect, "color:a", 0.0, fade_time)
	await tween.finished
