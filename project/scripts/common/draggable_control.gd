class_name DraggableControl extends Node

signal drag_start
signal drag_finished

const DEFAULT_Z: int = 0
const DRAG_Z: int = 50

var draggable: bool
var dragging: bool
var original_position: Vector2
func _input(event: InputEvent) -> void:
	if dragging and event is InputEventMouseMotion:
		getParent().onOffsetPosition(event.relative)
		
func _process(_delta: float) -> void:
	if !getParent().isDisabled():
		if Input.is_action_just_pressed("LeftClick") and getParent().isMouseInUI():
			if draggable:
				onDragStart()
				
	if Input.is_action_just_released("LeftClick") and draggable and dragging:
		onDragEnd()

func getParent() -> DefaultButton: return get_parent()
func setDraggable(_draggable: bool) -> void: draggable = _draggable
func onDragStart() -> void:
	var MainTarget: Control = getParent().getMainTarget()
	MainTarget.z_index = DRAG_Z
	
	original_position = MainTarget.global_position
	MainTarget.top_level = true
	MainTarget.global_position = original_position
	dragging = true
	
	getParent().setMouseFilter(Control.MouseFilter.MOUSE_FILTER_IGNORE)
	getParent().setDragMode(true)
	drag_start.emit()

func onDragEnd() -> void:
	var MainTarget: Control = getParent().getMainTarget()
	MainTarget.z_index = DEFAULT_Z
	dragging = false
	
	MainTarget.top_level = false
	MainTarget.global_position = original_position
	getParent().setMouseFilter(Control.MouseFilter.MOUSE_FILTER_STOP)
	getParent().setDragMode(false)
	
	drag_finished.emit()
