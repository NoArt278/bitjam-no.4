extends MeshInstance3D

@onready var area_3d: Area3D = $Area3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_3d.body_entered.connect(die)

func die(body: Node3D) -> void:
	if (body.name == "Player") :
		get_tree().reload_current_scene()
