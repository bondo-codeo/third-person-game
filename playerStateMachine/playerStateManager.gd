extends Node

enum groundStates {idle, walking, running, crouching}


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("forward"):
		print("walking")
	else:
		print("idle")
