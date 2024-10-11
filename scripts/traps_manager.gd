extends Node

const LASER = preload("res://scenes/traps/laser.tscn")
const SMALL_FLOOR = preload("res://scenes/small_floor.tscn")
const WHITE_MATERIAL = preload("res://assets/white_material.tres")
const BLUE_MATERIAL = preload("res://assets/blue_material.tres")
const GREEN_MATERIAL = preload("res://assets/green_material.tres")
const RED_MATERIAL = preload("res://assets/red_material.tres")
const DASH_REFILL = preload("res://scenes/dash_refill.tscn")
const ROTATING_LASER = preload("res://scenes/traps/rotating_laser.tscn")
const TrapsManager = preload("res://scripts/traps_manager.gd")
const traps_list = [LASER, ROTATING_LASER, SMALL_FLOOR]
const materials_list = [WHITE_MATERIAL, RED_MATERIAL, BLUE_MATERIAL, GREEN_MATERIAL]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(45) :
		var curr_trap = traps_list.pick_random()
		var curr_trap_instance = curr_trap.instantiate().duplicate()
		add_child(curr_trap_instance)
		curr_trap_instance.global_position.y = 70 + i * 20
		curr_trap_instance.global_rotation_degrees.y = randf_range(0, 360)
		
		if curr_trap != SMALL_FLOOR :
			randomize()
			var chosen_mat = materials_list.pick_random()
			curr_trap_instance.mesh.material = chosen_mat
			for j in range(2) :
				var dash_refill = DASH_REFILL.instantiate()
				add_child(dash_refill)
				dash_refill.position = Vector3(randf_range(-50,50), 70 + i * 20, randf_range(-50,50))
				dash_refill.mesh.material = chosen_mat
		else :
			randomize()
			curr_trap_instance.global_position.x = randf_range(-80, 80)
			curr_trap_instance.global_position.z = randf_range(-80, 80)
