extends Node3D

@export var speed := 2.0

func _physics_process(delta):
	translate(Vector3(0, 0, speed * delta))
