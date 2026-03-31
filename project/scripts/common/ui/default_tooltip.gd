class_name DefaultTooltip extends Node

@export var display_time: float = 0.2
@export var offset: Vector2
var tooltip_datas: Array[TooltipData]

func _ready() -> void:
	getDefaultControl().mouse_in_ui.connect(onMouseInUI)

func onUpdateTooltipDatas(_tooltip_datas: Array) -> void:
	tooltip_datas.assign(_tooltip_datas)

func onMouseInUI(mouse_in_ui: bool) -> void:
	Tooltip.onMouseInUI(mouse_in_ui, display_time, offset, tooltip_datas)
	
func getDefaultControl() -> DefaultControl: return get_parent()
