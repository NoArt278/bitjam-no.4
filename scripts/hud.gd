extends Control

@onready var color_rect: ColorRect = $ColorRect
@onready var color_rect_2: ColorRect = $ColorRect2
@onready var dash_charge_indicators = [color_rect, color_rect_2]
@onready var level_text: RichTextLabel = $LevelText
@onready var dash_charge_text: RichTextLabel = $DashChargeText

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
