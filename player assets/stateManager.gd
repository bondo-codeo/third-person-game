extends Node

enum groundStates {idle, walking, running, crouching}
enum airStates {onGround, jumping, falling}

var state = groundStates.idle

func _physics_process(delta):
	crouching()
	idle()
	walking()
	running()
	print(state)

func changeState(newState):
	state = newState

func idle():
	if Input.is_action_pressed("forward") and not Input.is_action_pressed("crouch"):
		changeState(groundStates.walking)
func walking():
	if Input.is_action_pressed("run") and not Input.is_action_pressed("crouch"):
		changeState(groundStates.running)
	if not Input.is_action_pressed("forward"):
		changeState(groundStates.idle)

func running():
	if Input.is_action_just_released("run") and state == groundStates.running:
		changeState(groundStates.walking)

func crouching():
	if Input.is_action_pressed("crouch"):
		changeState(groundStates.crouching)
