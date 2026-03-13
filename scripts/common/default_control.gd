class_name DefaultControl extends Node

signal mouse_in_ui
signal update_disabled

@export var HOVERED_DARKEN: float = 0.2
@export var MainTarget: Control
@export var mouse_self: bool = true
@export var mouse_nodes: Array[Control]
@export var autoscale: bool = false
@export var default_scale := Vector2.ONE
@export var base_color: Color = Color.WHITE

const SCALE_TIME: float = 0.25
const SCALE_MAX: float = 1.1
const DISABLED_DARKEN: float = 0.5

var drag_mode: bool
var is_mouse_in_ui: bool
var disabled: bool

var ScaleTween: Tween

func _ready() -> void:
	if mouse_self:
		mouse_nodes.append(MainTarget)
		setMouseFilter(Control.MOUSE_FILTER_STOP)
		
	for mouse_node: Control in mouse_nodes:
		mouse_node.mouse_exited.connect(onMouseInUI.bind(false))
		mouse_node.mouse_entered.connect(onMouseInUI.bind(true))
	onUpdateModulate()
		
func setMouseFilter(_mouse_filter: Control.MouseFilter) -> void:
	for mouse_node: Control in mouse_nodes:
		mouse_node.mouse_filter = _mouse_filter
	get_viewport().update_mouse_cursor_state()
		
func onMouseInUI(state: bool) -> void:
	is_mouse_in_ui = state
	onUpdateModulate()
	mouse_in_ui.emit(state)
	
	if !autoscale: return
	
	if ScaleTween: ScaleTween.kill()
	var new_scale := Vector2(SCALE_MAX, SCALE_MAX) if is_mouse_in_ui else default_scale
	MainTarget.pivot_offset = MainTarget.size / 2.0
	ScaleTween = create_tween()
	ScaleTween.tween_property(MainTarget, "scale", new_scale - MainTarget.scale, SCALE_TIME)\
		.as_relative().set_trans(Tween.TRANS_SINE)

func onUpdateModulate() -> void:
	var _base_color: Color = base_color
	if disabled:
		_base_color = _base_color.darkened(DISABLED_DARKEN)
	elif is_mouse_in_ui or drag_mode:
		_base_color = _base_color.darkened(HOVERED_DARKEN)
	MainTarget.modulate = _base_color

func _input(_event: InputEvent) -> void: pass
func setDisabled(state: bool) -> void:
	disabled = state
	onUpdateModulate()
	update_disabled.emit(disabled)

func isDisabled() -> bool: return disabled
func setBaseColor(_base_color: Color) -> void:
	base_color = _base_color
	onUpdateModulate()
	
func setDragMode(_drag_mode: bool) -> void:
	drag_mode = _drag_mode
	onUpdateModulate()
