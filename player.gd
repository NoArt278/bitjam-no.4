extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var mouse_sensitivity : float = 0.002
var mouse_pos_delta : Vector2 = Vector2.ZERO
@onready var camera_3d: Camera3D = $Camera3D
@onready var post_processing_mesh: MeshInstance3D = $Camera3D/PostProcessingShader
var post_process_material : Material
const color_filters : Array = [Vector3(1.0, 1.0, 1.0), Vector3(1.0, 0.0, 0.0), Vector3(0.0, 1.0, 0.0), Vector3(0.0, 0.0, 1.0)]
var curr_filter : int = 0

func _ready() -> void:
	post_process_material = post_processing_mesh.get_active_material(0)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("change_color") :
		curr_filter += 1
		curr_filter %= color_filters.size()
		post_process_material.set("shader_parameter/color_filter", color_filters[curr_filter])

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
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	if mouse_pos_delta.length() < 50 :
		rotate_y(mouse_pos_delta.x * mouse_sensitivity)
		$Camera3D.rotate_x(mouse_pos_delta.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))
	
	mouse_pos_delta = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion :
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED :
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		mouse_pos_delta = -event.relative
