extends CharacterBody2D
#export makes it editable in ui
@export var speed: float = 200.0
#onready makes it true when added to scenetree
@onready var footsteps: AudioStreamPlayer = $Footsteps

var can_move: bool = true
#movement
func _physics_process(delta):
	if not can_move:
		velocity.x = 0
		stop_footsteps()
		return

	var direction := Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed

	move_and_slide()
	handle_footsteps(direction)

func handle_footsteps(direction: float):
	if direction != 0:
		if not footsteps.playing:
			footsteps.play()
	else:
		stop_footsteps()

func stop_footsteps():
	if footsteps.playing:
		footsteps.stop()
#interaction management
@onready var interaction_area: Area2D = $InteractionArea

var current_interactable: Node = null

func _ready():
	interaction_area.body_entered.connect(_on_body_entered)
	interaction_area.body_exited.connect(_on_body_exited)
	DialogueManager.player_ref = self

func _on_body_entered(body):
	if body.is_in_group("interactable"):
		current_interactable = body


func _on_body_exited(body):
	if body == current_interactable:
		current_interactable = null

#interaction button manegement
func _input(event):
	if event.is_action_pressed("interact"):
		try_interact()

func try_interact():
	if current_interactable == null:
		return

	if current_interactable.has_method("interact"):
		current_interactable.interact()
