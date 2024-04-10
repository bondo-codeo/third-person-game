extends Node3D

var speed = 40

@onready var mesh = $MeshInstance3D

@onready var ray = $RayCast3D

@onready var particle = $GPUParticles3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.basis * Vector3(0, 0, -speed) * delta
	if ray.is_colliding():
		mesh.visible = false
		particle.emitting = true
		ray.enabled = false
		print("bullet hit something baby")
