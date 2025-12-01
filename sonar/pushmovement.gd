extends Node3D

var touching_boats := []

#func _on_area3d_body_entered(body):
#	if body.has_method("apply_track_push"):
#		touching_boats.append(body)

#func _on_area3d_body_exited(body):
#	touching_boats.erase(body)

func _physics_process(_delta):
	# apply push (the movement is handled by the parent Track)
	for boat in touching_boats:
		if boat and boat.has_method("apply_track_push"):
			boat.apply_track_push(0.08)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_method("apply_track_push"):
		touching_boats.append(body)
	print("ENTERED", body)


func _on_area_3d_body_exited(body: Node3D) -> void:
	touching_boats.erase(body)
