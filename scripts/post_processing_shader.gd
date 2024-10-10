extends MeshInstance3D

var post_process_material : Material
const color_filters : Array = [Vector3(1.0, 1.0, 1.0), Vector3(1.0, 0.0, 0.0), Vector3(0.0, 1.0, 0.0), Vector3(0.0, 0.0, 1.0)]
var curr_filter : int = 0
var hud : Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	post_process_material = get_active_material(0)
	hud = get_parent().get_node("%HUD")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("change_color") :
		curr_filter += 1
		curr_filter %= color_filters.size()
		post_process_material.set("shader_parameter/color_filter", color_filters[curr_filter])
		hud.change_color(Color(color_filters[curr_filter].x, color_filters[curr_filter].y, color_filters[curr_filter].z))
