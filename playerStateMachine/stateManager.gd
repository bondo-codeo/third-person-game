extends Node

enum groundStates {idle, walking, running, crouching, sliding, slideSwitch}
enum airStates {onGround, jumping, falling}
@onready var crouchCast = $"../crouchCheck"



var state = groundStates.idle


var slideTimer = 0.0
var slideTimerMax = 0.7

func _physics_process(delta):
	idle()
	walking()
	running()
	crouchCheck()
	sliding(delta)
	
func changeState(newState):
	state = newState

func idle():
	if Input.is_action_pressed("crouch") and not state == groundStates.sliding:
		changeState(groundStates.crouching)
	elif Input.is_action_pressed("forward") and not state == groundStates.sliding:
		changeState(groundStates.walking)
func walking():
	if Input.is_action_pressed("crouch") and not state == groundStates.sliding:
		changeState(groundStates.crouching) 
	elif Input.is_action_pressed("run") and not Input.is_action_pressed("crouch") and not state == groundStates.sliding and not state==groundStates.idle:
		changeState(groundStates.running)
	elif not Input.is_action_pressed("forward") and not state == groundStates.sliding:
		changeState(groundStates.idle)

func running():
	if Input.is_action_pressed("crouch") and not state == groundStates.sliding:
		changeState(groundStates.crouching)
	elif Input.is_action_just_released("run") and state == groundStates.running and not state == groundStates.sliding:
		changeState(groundStates.walking)
func sliding(delta):
	if Input.is_action_just_pressed("slide") and not state == groundStates.idle and not state == groundStates.crouching and not state == groundStates.sliding:
		changeState(groundStates.sliding)
		slideTimer = slideTimerMax
	if slideTimer > 0.0:
		slideTimer -= delta
	if slideTimer <= 0.0 and state == groundStates.sliding:
		changeState(groundStates.slideSwitch)
func crouchCheck():
	if crouchCast.is_colliding() and not state == groundStates.sliding:
		changeState(groundStates.crouching)