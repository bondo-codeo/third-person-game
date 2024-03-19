extends CharacterBody3D

@export var normalMovement : playerMovementData

var direction = Vector3.ZERO
@export var mouseSensitivity = .3

@onready var head = $head

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var stateManager = $stateManager


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
