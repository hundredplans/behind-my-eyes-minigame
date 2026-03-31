extends Node

@onready var TooltipUI: Node2D = %TooltipUI
@onready var TooltipTimer: Timer = %TooltipTimer
var offset: Vector2
var tooltip_datas: Array[TooltipData]
func _ready() -> void: onHideTooltipUI()
func onMouseInUI(mouse_in_ui: bool, display_time: float, _offset: Vector2, _tooltip_datas: Array[TooltipData]) -> void:
	offset = _offset
	tooltip_datas = _tooltip_datas
	if !mouse_in_ui or tooltip_datas.is_empty():
		onHideTooltipUI()
		TooltipTimer.stop()
		return
	TooltipTimer.start(display_time)

func onHideTooltipUI() -> void: TooltipUI.visible = false
func onShowTooltipUI() -> void: TooltipUI.visible = true

func onTooltipTimerTimeout() -> void:
	if tooltip_datas.is_empty():
		onHideTooltipUI()
		TooltipTimer.stop()
		return
		
	onShowTooltipUI()
	TooltipUI.global_position = offset + get_viewport().get_mouse_position()
	TooltipUI.setTooltipData(tooltip_datas[0]) # Temp

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		TooltipUI.position += event.relative
