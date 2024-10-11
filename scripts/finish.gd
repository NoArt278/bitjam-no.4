extends Area3D

signal finish

func _on_body_entered(body: Node3D) -> void:
	if body is Player :
		# Save time
		finish.emit()
