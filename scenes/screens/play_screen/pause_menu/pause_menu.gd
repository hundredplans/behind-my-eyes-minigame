extends Control

@onready var ButtonsContainer: Container = %ButtonsContainer
@onready var ResumeDefaultButton: DefaultButton = %ResumeDefaultButton
@onready var SettingsDefaultButton: DefaultButton = %SettingsDefaultButton
@onready var ExitDefaultButton: DefaultButton = %ExitDefaultButton
@onready var BackgroundRect: ColorRect = %BackgroundRect

@export var start_color: Color
@export var scale_in_end_alpha: float
@export var scale_in_time: float = 0.5

var is_scaled_in: bool
func setInfo() -> void:
	ButtonsContainer.pivot_offset = size / 2.0
	ButtonsContainer.scale = Vector2.ZERO
	
	var tween := create_tween()
	tween.tween_property(ButtonsContainer, "scale", Vector2.ONE, scale_in_time)\
		.as_relative().set_trans(Tween.TRANS_SINE)
	tween.finished.connect(onScaleInFinished)
	
	BackgroundRect.color = start_color
	var mtween := create_tween()
	mtween.tween_property(BackgroundRect, "color:a", scale_in_end_alpha, scale_in_time)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Escape") and is_scaled_in:
		onScaleOut()
		
func onScaleOut() -> void:
	is_scaled_in = false
	var tween := create_tween()
	tween.tween_property(ButtonsContainer, "scale", -Vector2.ONE, scale_in_time)\
		.as_relative().set_trans(Tween.TRANS_SINE)
	tween.finished.connect(onScaleOutFinished)
	
	var mtween := create_tween()
	mtween.tween_property(BackgroundRect, "modulate:a", 0.0, scale_in_time)

func onScaleInFinished() -> void:
	is_scaled_in = true
	
func onScaleOutFinished() -> void:
	queue_free()
	
func getButtons() -> Array: return [ResumeDefaultButton, SettingsDefaultButton, ExitDefaultButton]

func onResumeButtonPressed() -> void:
	pass # Replace with function body.

func onSettingsButtonPressed() -> void:
	pass # Replace with function body.

func onExitButtonPressed() -> void:
	pass # Replace with function body.
