extends Node3D

var speed = 90

@onready var mesh_instance_3d = $MeshInstance3D

@onready var ray_cast_3d = $RayCast3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.basis * Vector3(0, 0, -speed) * delta
	
