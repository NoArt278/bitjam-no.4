extends Control

@onready var color_rect: ColorRect = $ColorRect
@onready var color_rect_2: ColorRect = $ColorRect2
@onready var dash_charge_indicators = [color_rect, color_rect_2]
@onready var dash_charge_text: RichTextLabel = $DashChargeText
@onready var timer_text: RichTextLabel = $TimerText
@onready var best_score: RichTextLabel = $BestScore
const POST_PROCESS_MATERIAL = preload("res://assets/post_process_material.tres")
var start_time
var prev_best = INF

func _ready() -> void:
	start_time = Time.get_ticks_msec()
	var curr_color = POST_PROCESS_MATERIAL.get("shader_parameter/color_filter")
	change_color(Color(curr_color.x, curr_color.y, curr_color.z))
	if not FileAccess.file_exists("user://highscore.save"):
		return
	var save_file = FileAccess.open("user://highscore.save", FileAccess.READ)
	prev_best = save_file.get_32()
	if prev_best != INF :
		best_score.visible = true
		best_score.text = "Best : " + str(round(prev_best/1000)) + "\"" + str(prev_best%1000)

func update_dash_charge(dash_charge: int):
	for i in range(2) :
		if i < dash_charge:
			dash_charge_indicators[i].visible = true
		else:
			dash_charge_indicators[i].visible = false

func change_color(color: Color):
	for di in dash_charge_indicators:
		di.color = color
	dash_charge_text.add_theme_color_override("default_color", color)
	best_score.add_theme_color_override("default_color", color)
	timer_text.add_theme_color_override("default_color", color)

func _process(_delta: float) -> void:
	var curr_time = Time.get_ticks_msec() - start_time
	timer_text.text = "[right]" + str(round(curr_time/1000)) + "\"" + str(curr_time%1000) + "[/right]"


func _on_finish_finish() -> void:
	var curr_time = Time.get_ticks_msec() - start_time
	if curr_time < prev_best :
		var save_file = FileAccess.open("user://highscore.save", FileAccess.WRITE)
		save_file.store_32(curr_time)
	get_tree().call_deferred("reload_current_scene")
