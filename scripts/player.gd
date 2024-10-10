extends CharacterBody3D

class_name Player

const ACCELERATION = 50.0
const DECELERATION = 1.0
const JUMP_VELOCITY = 12.0
const SHEAR_SPEED = 30.0
const SHEAR_ANGLE_Z = 20.0
const SHEAR_ANGLE_X = 15.0
const MAX_SPEED = 30.0
const DASH_SPEED = 60.0
var mouse_sensitivity : float = 0.003
var mouse_pos_delta : Vector2 = Vector2.ZERO
var is_dashing : bool = false
var dash_charges : int = 2
@onready var camera_anchor: Node3D = $CameraAnchor
@onready var camera_3d: Camera3D = $CameraAnchor/Camera3D
@onready var dash_timer: Timer = $DashTimer
@onready var dash_cd_timer: Timer = $DashCDTimer
@onready var hud: Control = %HUD

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * 3 * delta
	elif dash_charges < 2 and dash_cd_timer.is_stopped() :
		dash_charges = 2
		hud.update_dash_charge(dash_charges)

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and not(is_dashing):
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and not(is_dashing) :
		velocity.x += direction.x * ACCELERATION * delta
		velocity.z += direction.z * ACCELERATION * delta
		if abs(velocity.length()) > MAX_SPEED :
			velocity = MAX_SPEED * velocity.normalized()
		camera_anchor.rotation_degrees.x = move_toward(camera_anchor.rotation_degrees.x, SHEAR_ANGLE_X * sign(input_dir.y), SHEAR_SPEED * delta)
		camera_anchor.rotation_degrees.z = move_toward(camera_anchor.rotation_degrees.z, SHEAR_ANGLE_Z * sign(input_dir.x) * -1, SHEAR_SPEED * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION)
		velocity.z = move_toward(velocity.z, 0, DECELERATION)
		camera_anchor.rotation_degrees.x = move_toward(camera_anchor.rotation_degrees.x, 0, SHEAR_SPEED * delta)
		camera_anchor.rotation_degrees.z = move_toward(camera_anchor.rotation_degrees.z, 0, SHEAR_SPEED * delta)
	
	if Input.is_action_just_pressed("dash") and dash_charges > 0 and not(is_dashing) :
		velocity = -camera_3d.global_transform.basis.z * DASH_SPEED
		dash_charges -= 1
		is_dashing = true
		dash_timer.start()
		hud.update_dash_charge(dash_charges)
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


func _on_dash_timer_timeout() -> void:
	is_dashing = false

func add_dash_charge() -> void:
	dash_charges += 1
	hud.update_dash_charge(dash_charges)
