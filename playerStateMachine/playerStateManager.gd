extends Node

enum groundStates {idle, walking, running, crouching}
enum airStates {onGround, jumping, falling}

var state = groundStates.idle

func _physics_process(delta):
	idle()
	walking()
	running()
	print(state)

func changeState(newState):
	state = newState

func idle():
	if Input.is_action_pressed("forward"):
		changeState(groundStates.walking)

func walking():
	if Input.is_action_pressed("run"):
		changeState(groundStates.running)
	if !Input.is_action_pressed("forward"):
		changeState(groundStates.idle)

func running():
	if Input.is_action_just_released("run"):
		changeState(groundStates.walking)

func crouching():
	print("crouch")
