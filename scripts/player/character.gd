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
@onready var currentState = stateManager.state

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
	currentState = stateManager.state
	stateMatching(direction, delta)
	guiManagement()
	move_and_slide()

func applyGravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = normalMovement.jumpVelocity

func stateMatching(dir, delta):
	match currentState:
		stateManager.groundStates.idle:
			velocity.x = lerp(velocity.x, 0.0, normalMovement.lerpDrag * delta)
			velocity.z = lerp(velocity.z, 0.0, normalMovement.lerpDrag * delta)
			head.position.y = lerp(head.position.y, standHeight, cameraLerp)
			camera.fov = lerp(camera.fov, idleFov, cameraLerp)
			standingCol.disabled = false
			crouchingCol.disabled = true
	
		stateManager.groundStates.walking:
			velocity.x = lerp(velocity.x, dir.x * normalMovement.walkSpeed, normalMovement.lerpDrag * delta)
			velocity.z = lerp(velocity.z, dir.z * normalMovement.walkSpeed, normalMovement.lerpDrag * delta)
			head.position.y = lerp(head.position.y, standHeight, cameraLerp)
			camera.fov = lerp(camera.fov, walkingFov, cameraLerp)
			standingCol.disabled = false
			crouchingCol.disabled = true
	
		stateManager.groundStates.running:
			velocity.x = lerp(velocity.x, dir.x * normalMovement.runSpeed, normalMovement.lerpDrag * delta)
			velocity.z = lerp(velocity.z, dir.z * normalMovement.runSpeed, normalMovement.lerpDrag * delta)
			head.position.y = lerp(head.position.y, standHeight, cameraLerp)
			camera.fov = lerp(camera.fov, runningFov, cameraLerp)
			standingCol.disabled = false
			crouchingCol.disabled = true
	
		stateManager.groundStates.crouching:
			velocity.x = lerp(velocity.x, dir.x * normalMovement.crouchSpeed, normalMovement.lerpDrag * delta)
			velocity.z = lerp(velocity.z, dir.z * normalMovement.crouchSpeed, normalMovement.lerpDrag * delta)
			head.position.y = lerp(head.position.y, crouchHeight, cameraLerp)
			camera.fov = lerp(camera.fov, crouchingFov, cameraLerp)
			standingCol.disabled = true
			crouchingCol.disabled = false
	
		stateManager.groundStates.sliding:
			head.position.y = lerp(head.position.y, crouchHeight, cameraLerp)
			camera.fov = lerp(camera.fov, slidingFov, cameraLerp)
			standingCol.disabled = true
			crouchingCol.disabled = false



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
