extends Node

enum groundStates {idle, walking, running, crouching}


var state = groundStates.idle

func _input(event):
	var input = event
	print(input)

#func _physics_process(delta):
	


func changeState(newState):
	state = newState


