extends Control

@onready var color_rect: ColorRect = $ColorRect
@onready var color_rect_2: ColorRect = $ColorRect2
@onready var dash_charge_indicators = [color_rect, color_rect_2]
@onready var level_text: RichTextLabel = $LevelText
@onready var dash_charge_text: RichTextLabel = $DashChargeText
@onready var timer_text: RichTextLabel = $TimerText
const POST_PROCESS_MATERIAL = preload("res://assets/post_process_material.tres")
var start_time

func _ready() -> void:
	start_time = Time.get_ticks_msec()
	var curr_color = POST_PROCESS_MATERIAL.get("shader_parameter/color_filter")
	change_color(Color(curr_color.x, curr_color.y, curr_color.z))

func update_dash_charge(dash_charge: int):
	for i in range(2) :
		if i < dash_charge:
			dash_charge_indicators[i].visible = true
		else:
			dash_charge_indicators[i].visible = false

func change_color(color: Color):
	for di in dash_charge_indicators:
		di.color = color
	level_text.add_theme_color_override("default_color", color)
	dash_charge_text.add_theme_color_override("default_color", color)
	timer_text.add_theme_color_override("default_color", color)

func _process(delta: float) -> void:
	var curr_time = Time.get_ticks_msec() - start_time
	timer_text.text = "[right]" + str(round(curr_time/1000)) + "\"" + str(curr_time%1000) + "[/right]"
