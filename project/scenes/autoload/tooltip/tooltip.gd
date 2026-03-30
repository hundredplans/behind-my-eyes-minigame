extends Node

@onready var TooltipUI: Node2D = %TooltipUI
@onready var TooltipTimer: Timer = %TooltipTimer
var offset: Vector2
var entity_object: EntityObject
func _ready() -> void: onHideTooltipUI()
	
func onMouseInUI(mouse_in_ui: bool, display_time: float, _offset: Vector2, _entity_object: EntityObject) -> void:
	offset = _offset
	entity_object = _entity_object
	if !mouse_in_ui or entity_object == null:
		onHideTooltipUI()
		TooltipTimer.stop()
		return
	TooltipTimer.start(display_time)

func onHideTooltipUI() -> void: TooltipUI.visible = false
func onShowTooltipUI() -> void: TooltipUI.visible = true

func onTooltipTimerTimeout() -> void:
	if entity_object == null:
		onHideTooltipUI()
		TooltipTimer.stop()
		return
		
	onShowTooltipUI()
	TooltipUI.global_position = offset + get_viewport().get_mouse_position()
	TooltipUI.setEntityObject(entity_object)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		TooltipUI.position += event.relative
