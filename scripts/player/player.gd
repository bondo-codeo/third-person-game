extends CharacterBody3D


@onready var character = $baseCharacter

@export var humanClass : humanoid

@onready var standingCol = $standingCol
@onready var crouchingCol = $crouchingCol

var direction = Vector3.ZERO
@export var mouseSensitivity = .3


@onready var head = $head
@onready var camera = $head/offset/camSpring/Camera3D
@onready var camSpring = $head/offset/camSpring


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
	#mouse rotation
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(event.relative.x * mouseSensitivity * -1))
		head.rotate_x(deg_to_rad(event.relative.y * mouseSensitivity * -1))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-80), deg_to_rad(85))


func _physics_process(delta):
	applyGravity(delta)
	jump()
	
	
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = transform.basis * Vector3(input_dir.x, 0, input_dir.y).normalized()
	currentState = stateManager.state
	character.rotateTorso(head.rotation.x, delta)
	
	if Input.is_action_just_pressed("fire"):
		character.hit()
	
	stateMatching(direction, delta)
	guiManagement()
	cameraZoom()
	move_and_slide()

func applyGravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = humanClass.jumpPower

func stateMatching(dir, delta):
	match currentState:
		stateManager.groundStates.idle:
			velocity.x = lerp(velocity.x, 0.0, humanClass.lerpDrag * delta)
			velocity.z = lerp(velocity.z, 0.0, humanClass.lerpDrag * delta)
			head.position.y = lerp(head.position.y, standHeight, cameraLerp)
			camera.fov = lerp(camera.fov, idleFov, cameraLerp)
			standingCol.disabled = false
			crouchingCol.disabled = true
			character.idle()
	
		stateManager.groundStates.walking:
			velocity.x = lerp(velocity.x, dir.x * humanClass.walkSpeed, humanClass.lerpDrag * delta)
			velocity.z = lerp(velocity.z, dir.z * humanClass.walkSpeed, humanClass.lerpDrag * delta)
			head.position.y = lerp(head.position.y, standHeight, cameraLerp)
			camera.fov = lerp(camera.fov, walkingFov, cameraLerp)
			standingCol.disabled = false
			crouchingCol.disabled = true
			character.walk()
	
		stateManager.groundStates.running:
			velocity.x = lerp(velocity.x, dir.x * humanClass.runSpeed, humanClass.lerpDrag * delta)
			velocity.z = lerp(velocity.z, dir.z * humanClass.runSpeed, humanClass.lerpDrag * delta)
			head.position.y = lerp(head.position.y, standHeight, cameraLerp)
			camera.fov = lerp(camera.fov, runningFov, cameraLerp)
			standingCol.disabled = false
			crouchingCol.disabled = true
			character.run()
	
		stateManager.groundStates.crouchingIdle:
			velocity.x = lerp(velocity.x, 0.0, humanClass.lerpDrag * delta)
			velocity.z = lerp(velocity.z, 0.0, humanClass.lerpDrag * delta)
			head.position.y = lerp(head.position.y, crouchHeight, cameraLerp)
			camera.fov = lerp(camera.fov, crouchingFov, cameraLerp)
			standingCol.disabled = true
			crouchingCol.disabled = false
			character.crouchIdle()
	
		stateManager.groundStates.crouchWalking:
			velocity.x = lerp(velocity.x, dir.x * humanClass.crouchSpeed, humanClass.lerpDrag * delta)
			velocity.z = lerp(velocity.z, dir.z * humanClass.crouchSpeed, humanClass.lerpDrag * delta)
			head.position.y = lerp(head.position.y, crouchHeight, cameraLerp)
			camera.fov = lerp(camera.fov, crouchingFov, cameraLerp)
			standingCol.disabled = true
			crouchingCol.disabled = false
			character.crouchWalk()
	
		stateManager.groundStates.sliding:
			camera.fov = lerp(camera.fov, slidingFov, cameraLerp)
			standingCol.disabled = true
			crouchingCol.disabled = false
			character.slide()

func cameraZoom():
	if Input.is_action_just_released("scrollUp") and camSpring.spring_length > 1.4:
		camSpring.spring_length -= 0.1
	elif Input.is_action_just_released("scrollDown") and camSpring.spring_length < 3:
		camSpring.spring_length += 0.1

func guiManagement():
	if stateManager.state == stateManager.groundStates.idle:
		stateInfo.text = "[center]State = Idle[center]"
	if stateManager.state == stateManager.groundStates.walking:
		stateInfo.text = "[center]State = Walking[center]"
	if stateManager.state == stateManager.groundStates.running:
		stateInfo.text = "[center]State = Running[center]"
	if stateManager.state == stateManager.groundStates.crouchingIdle:
		stateInfo.text = "[center]State = CrouchingIdle[center]"
	if stateManager.state == stateManager.groundStates.sliding:
		stateInfo.text = "[center]State = Sliding[center]"
	if stateManager.state == stateManager.groundStates.crouchWalking:
		stateInfo.text = "[center]State = crouchWalking[center]"
#testing if committing in main will fuck things up
