extends MeshInstance3D


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player :
		body.add_dash_charge()
		queue_free()
