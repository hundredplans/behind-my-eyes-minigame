class_name DefaultTooltip extends Node

@export var display_time: float = 0.2
@export var offset: Vector2
var entity_object: EntityObject

func _ready() -> void:
	getDefaultControl().mouse_in_ui.connect(onMouseInUI)

func onUpdateEntityObject(_entity_object: EntityObject) -> void: entity_object = _entity_object

func onMouseInUI(mouse_in_ui: bool) -> void:
	Tooltip.onMouseInUI(mouse_in_ui, display_time, offset, entity_object)
	
func getDefaultControl() -> DefaultControl: return get_parent()
