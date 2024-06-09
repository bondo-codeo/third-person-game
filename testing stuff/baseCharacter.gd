extends Node3D
@onready var animations = $AnimationPlayer
@onready var torso = $torso

func idle():
	animations.play("idle")
func walk():
	animations.play("walk")
func run():
	animations.play("run")
func crouchIdle():
	animations.play("crouchIdle")
func crouchWalk():
	animations.play("crouchWalk")


func rotateTorso(offset):
	torso.rotation.x = lerp(torso.rotation.x, -offset, 0.2)
	torso.rotation.x = clamp(torso.rotation.x, deg_to_rad(-50), deg_to_rad(50))
