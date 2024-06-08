extends Node

#lots of spaghetti here, will get around to fixing it eventually but for now it works

enum groundStates {idle, walking, running, crouchingIdle, crouchWalking, sliding, slideSwitch}
enum airStates {onGround, jumping, falling}

@onready var crouchCast = $crouchCheck




var state = groundStates.idle


var slideTimer = 0.0
var slideTimerMax = 0.7

func _physics_process(delta):
	stateManager()
	crouchCheck()
	sliding(delta)
	print(moving())


func changeState(newState):
	state = newState
	
func moving():
	if Input.is_action_pressed("forward") or Input.is_action_pressed("backward") or Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		return true
	else:
		return false

func stateManager():
	if not Input.is_action_pressed("crouch") and not state == groundStates.sliding and not crouchCast.is_colliding() and not moving():
		changeState(groundStates.idle)
		#if no movement ubttons are pressed go idle
	if Input.is_action_pressed("crouch") and not state == groundStates.sliding:
		if not moving():
			changeState(groundStates.crouchingIdle)
		else:
			changeState(groundStates.crouchWalking)
		#if crouching button pressed crouch
	elif moving() and not Input.is_action_pressed("crouch") and not state == groundStates.sliding:
			if Input.is_action_pressed("run") and Input.is_action_pressed("forward"):
				changeState(groundStates.running)
				#if pressing forward and running buttons run
			else:
				changeState(groundStates.walking)
				#if not pressing running button but pressing WASD buttons walk
	
func sliding(delta):
	if Input.is_action_just_pressed("slide") and not state == groundStates.idle and not state == groundStates.crouchingIdle and not state == groundStates.crouchWalking and not state == groundStates.sliding:
		changeState(groundStates.sliding)
		slideTimer = slideTimerMax
	if slideTimer > 0.0:
		slideTimer -= delta
	if slideTimer <= 0.0 and state == groundStates.sliding:
		changeState(groundStates.slideSwitch)

func crouchCheck():
	if crouchCast.is_colliding() and not state == groundStates.sliding:
		if moving():
			changeState(groundStates.crouchWalking)
		else:
			changeState(groundStates.crouchingIdle)
		

