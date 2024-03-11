extends CharacterBody3D


var direction = Vector3.ZERO

@export var walkSpeed = 5
@export var jumpVelocity = 4
@export var mouseSensitivity = .3

@onready var head = $head

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

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
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	walk(direction)
	move_and_slide()

func applyGravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jumpVelocity
func walk(dir):
	if dir:
		velocity.x = dir.x * walkSpeed
		velocity.z = dir.z * walkSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, walkSpeed)
		velocity.z = move_toward(velocity.z, 0, walkSpeed)
##test
