extends Node3D

@onready var animation_player: AnimationPlayer = $SwordMesh/AnimationPlayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack") :
		animation_player.play("attack")
		await animation_player.animation_finished
