extends Node

@onready var TooltipUI: Control = %TooltipUI
@onready var TooltipTimer: Timer = %TooltipTimer

var offset: Vector2
var tooltip_datas: Array[TooltipData]
func _ready() -> void: onHideTooltipUI()
func onMouseInUI(mouse_in_ui: bool, display_time: float, _offset: Vector2, _tooltip_datas: Array[TooltipData]) -> void:
	tooltip_datas = _tooltip_datas
	if !mouse_in_ui or tooltip_datas.is_empty():
		onHideTooltipUI()
		TooltipTimer.stop()
		return
	TooltipTimer.start(display_time)
	TooltipUI.setTooltipData(tooltip_datas[0]) # Updating this here so cont has time to resize
	# change this if we're adding nested tooltips ^

func onHideTooltipUI() -> void: TooltipUI.visible = false
func onShowTooltipUI() -> void: TooltipUI.visible = true

func onTooltipTimerTimeout() -> void:
	if tooltip_datas.is_empty():
		onHideTooltipUI()
		TooltipTimer.stop()
		return
		
	onShowTooltipUI()
	onUpdateTooltipUIPosition(-TooltipUI.global_position + Vector2(7, -TooltipUI.size.y / 2.0) + get_viewport().get_mouse_position())

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		onUpdateTooltipUIPosition(event.relative)

func onUpdateTooltipUIPosition(_offset: Vector2) -> void:
	TooltipUI.global_position += _offset
	onClampTooltipUI()

func onClampTooltipUI() -> void:
	var x: float = TooltipUI.global_position.x
	var y: float = TooltipUI.global_position.y
	var d: float = 2.0
	TooltipUI.global_position = Vector2(clamp(x, d, (640 - d - TooltipUI.size.x)), clamp(y, d, (360 - d - TooltipUI.size.y)))
