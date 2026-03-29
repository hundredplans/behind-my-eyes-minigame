class_name DefaultTooltip extends Node

@export var display_time: float = 0.2
@export var offset: Vector2
var TooltipUI: Control

func _ready() -> void:
	getDefaultControl().mouse_in_ui.connect(onMouseInUI)

func onMouseInUI(mouse_in_ui: bool) -> void:
	if !mouse_in_ui:
		if is_instance_valid(TooltipUI): TooltipUI.queue_free()
		return
	
	#await get_tree().create_timer()
	
func getDefaultControl() -> DefaultControl: return get_parent()
