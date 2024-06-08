extends Node3D
@onready var animations = $AnimationPlayer

func idle():
	animations.play("idle")
func walk():
	animations.play("walk")
func run():
	animations.play("run")
