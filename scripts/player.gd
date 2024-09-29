extends CharacterBody3D


const ACCELERATION = 50.0
const DECELERATION = 1.0
const JUMP_VELOCITY = 4.5
const SHEAR_SPEED = 40.0
const SHEAR_ANGLE = 20.0
const MAX_SPEED = 30.0
var mouse_sensitivity : float = 0.002
var mouse_pos_delta : Vector2 = Vector2.ZERO
@onready var camera_anchor: Node3D = $CameraAnchor
@onready var camera_3d: Camera3D = $CameraAnchor/Camera3D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x += direction.x * ACCELERATION * delta
		velocity.z += direction.z * ACCELERATION * delta
		if abs(velocity.x) > MAX_SPEED :
			velocity.x = MAX_SPEED * direction.x
		if abs(velocity.z) > MAX_SPEED :
			velocity.z = MAX_SPEED * direction.z
		camera_anchor.rotation_degrees.z = move_toward(camera_anchor.rotation_degrees.z, SHEAR_ANGLE * input_dir.x * -1, SHEAR_SPEED * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION)
		velocity.z = move_toward(velocity.z, 0, DECELERATION)
		camera_anchor.rotation_degrees.z = move_toward(camera_anchor.rotation_degrees.z, 0, SHEAR_SPEED * delta)

	move_and_slide()
	
	if mouse_pos_delta.length() < 50 :
		rotate_y(mouse_pos_delta.x * mouse_sensitivity)
		camera_3d.rotate_x(mouse_pos_delta.y * mouse_sensitivity)
		camera_3d.rotation.x = clampf(camera_3d.rotation.x, -deg_to_rad(70), deg_to_rad(70))
	
	mouse_pos_delta = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion :
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED :
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		mouse_pos_delta = -event.relative
