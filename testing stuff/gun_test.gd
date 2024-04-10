extends Node3D

@onready var barrel = $barrel

@onready var bullet = load("res://testing stuff/bullet.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("fire"):
		var instance = bullet.instantiate()
		instance.position = barrel.global_position
		instance.transform.basis = barrel.global_transform.basis
		get_tree().get_root().add_child(instance)
		print("bullet fired baby")
