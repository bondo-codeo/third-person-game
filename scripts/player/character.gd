extends CharacterBody3D

@export var normalMovement : playerMovementData
@onready var standingCol = $standingCol
@onready var crouchingCol = $crouchingCol

var direction = Vector3.ZERO
@export var mouseSensitivity = .3

@onready var head = $head
@onready var camera = $head/Camera3D

@onready var stateInfo = $CanvasLayer/Panel/stateInfo

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var stateManager = $stateManager

var standHeight = 0.5
var crouchHeight = -0.1

var idleFov = 75.0
var walkingFov = 80.0
var runningFov = 85.0
var slidingFov = 90.0
var crouchingFov = 70.0
var cameraLerp = 0.5

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	 
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(event.relative.x * mouseSensitivity * -1))
		head.rotate_x(deg_to_rad(event.relative.y * mouseSensitivity * -1))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-80), deg_to_rad(85))

func _physics_process(delta):
	applyGravity(delta)
	jump()
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), normalMovement.lerpDrag * delta)
	
	movement(direction, delta)
	cameraManagement()
	colManagement()
	guiManagement()
	move_and_slide()
	print(stateManager.state)

func applyGravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = normalMovement.jumpVelocity


func movement(dir, delta):
	if stateManager.state == stateManager.groundStates.idle:
		velocity.x = lerp(velocity.x, 0.0, normalMovement.lerpDrag * delta)
		velocity.z = lerp(velocity.z, 0.0, normalMovement.lerpDrag * delta)
	
	if stateManager.state == stateManager.groundStates.walking:
		velocity.x = dir.x * normalMovement.walkSpeed
		velocity.z = dir.z * normalMovement.walkSpeed
	
	if stateManager.state == stateManager.groundStates.running:
		velocity.x = dir.x * normalMovement.runSpeed
		velocity.z = dir.z * normalMovement.runSpeed
	
	if stateManager.state == stateManager.groundStates.crouching:
		velocity.x = dir.x * normalMovement.crouchSpeed
		velocity.z = dir.z * normalMovement.crouchSpeed
	
func cameraManagement():
	if stateManager.state == stateManager.groundStates.crouching or stateManager.state == stateManager.groundStates.sliding:
		head.position.y = lerp(head.position.y, crouchHeight, cameraLerp)
	elif not stateManager.state == stateManager.groundStates.crouching or stateManager.state == stateManager.groundStates.sliding:
		head.position.y = lerp(head.position.y, standHeight, cameraLerp)
	#here we manage camera fov
	if stateManager.state == stateManager.groundStates.idle:
		camera.fov = lerp(camera.fov, idleFov, cameraLerp)
	if stateManager.state == stateManager.groundStates.walking:
		camera.fov = lerp(camera.fov, walkingFov, cameraLerp)
	if stateManager.state == stateManager.groundStates.running:
		camera.fov = lerp(camera.fov, runningFov, cameraLerp)
	if stateManager.state == stateManager.groundStates.crouching:
		camera.fov = lerp(camera.fov, crouchingFov, cameraLerp)
	if stateManager.state == stateManager.groundStates.sliding:
		camera.fov = lerp(camera.fov, slidingFov, cameraLerp)
	
func colManagement():
	if stateManager.state == stateManager.groundStates.crouching or stateManager.state == stateManager.groundStates.sliding:
		standingCol.disabled = true
		crouchingCol.disabled = false
	elif not stateManager.state == stateManager.groundStates.crouching or not stateManager.state == stateManager.groundStates.sliding:
		standingCol.disabled = false
		crouchingCol.disabled = true
func guiManagement():
	if stateManager.state == stateManager.groundStates.idle:
		stateInfo.text = "[center]State = Idle[center]"
	if stateManager.state == stateManager.groundStates.walking:
		stateInfo.text = "[center]State = Walking[center]"
	if stateManager.state == stateManager.groundStates.running:
		stateInfo.text = "[center]State = Running[center]"
	if stateManager.state == stateManager.groundStates.crouching:
		stateInfo.text = "[center]State = Crouching[center]"
	if stateManager.state == stateManager.groundStates.sliding:
		stateInfo.text = "[center]State = Sliding[center]"
#testing if committing in main will fuck things up
