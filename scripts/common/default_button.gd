class_name DefaultButton extends DefaultControl

@export_group("Flash")
@export var flash: bool
@export var flash_color := Color("ffffad")
@export var flash_duration: float = 1.0
@export_group("")
@export var auto_disable: bool
@export var auto_disable_right_click: bool

signal right_clicked
signal pressed

func _ready() -> void:
	super()
	onCheckFlash()
	
func setFlash(state: bool) -> void:
	if flash == state: return
	flash = state
	onCheckFlash()

func _process(_delta: float) -> void:
	if is_mouse_in_ui and !disabled:
		if Input.is_action_just_pressed("LeftClick"):
			pressed.emit()
			if auto_disable: setDisabled(true)
		elif Input.is_action_just_pressed("RightClick"):
			right_clicked.emit()
			if auto_disable_right_click: setDisabled(true)
		
func onMouseInUI(state: bool) -> void:
	super(state)
	call_deferred("onUpdateMouseCursorShape")
	
func setDisabled(state: bool) -> void:
	super(state)
	onUpdateMouseCursorShape()
	
func onUpdateMouseCursorShape() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW if (disabled or !is_mouse_in_ui) else Input.CURSOR_POINTING_HAND)
	MainTarget.mouse_default_cursor_shape = Control.CURSOR_ARROW if (disabled or !is_mouse_in_ui) else Control.CURSOR_POINTING_HAND
	get_viewport().call_deferred("update_mouse_cursor_state")

var FlashTween: Tween
func onCheckFlash() -> void:
	if flash: onFlash()
		
func onFlash() -> void:
	if !flash: return
	if FlashTween: FlashTween.kill()
	FlashTween = create_tween()
	FlashTween.tween_property(MainTarget, "self_modulate", flash_color, flash_duration)
	FlashTween.tween_property(MainTarget, "self_modulate", Color.WHITE, flash_duration)
	FlashTween.finished.connect(onFlash)
