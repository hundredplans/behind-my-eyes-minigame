extends Node2D

signal turn_timer_timeout
@onready var BorderCircleSprite: Sprite2D = %BorderCircleSprite
@onready var InnerCircleSprite: Sprite2D = %InnerCircleSprite

@onready var FlashingStartTimer: Timer = %FlashingStartTimer
@onready var TurnTimer: Timer = %TurnTimer

@export var start_timer_color: Color
@export var end_timer_color: Color
@export var disabled_color: Color

@export var total_flash_duration: float = 3.0
@export var flash_time: float = 0.5

var flashing: bool
var EndTimerAudioStreamPlayer: AudioStreamPlayer

func _ready() -> void:
	Actions.action_chain_started.connect(onDelayTimerStart)
	Actions.action_chain_ended.connect(onDelayTimerEnd)
	InnerCircleSprite.self_modulate = start_timer_color

func onStart() -> void:
	TurnTimer.start(Data.TURN_TIME)
	FlashingStartTimer.start(Data.TURN_TIME - total_flash_duration)
	flashing = false
	
func onDelayTimerStart() -> void:
	modulate = disabled_color
	TurnTimer.set_paused(true)
	FlashingStartTimer.set_paused(true)
	
func onDelayTimerEnd() -> void:
	modulate = Color.WHITE
	TurnTimer.set_paused(false)
	FlashingStartTimer.set_paused(false)

func _process(_delta: float) -> void:
	if TurnTimer.paused: return
	
	var weight: float = abs((TurnTimer.time_left / TurnTimer.wait_time) - 1)
	InnerCircleSprite.set_instance_shader_parameter("progress", weight)
	
	var new_color: Color = start_timer_color
	new_color.h = lerp(start_timer_color.h, end_timer_color.h, weight)
	InnerCircleSprite.self_modulate = new_color

func onFlashingStartTimerTimeout() -> void:
	flashing = true
	onFlash()
	
func onFlash() -> void:
	if !flashing: return
	var tween := create_tween()
	tween.tween_property(BorderCircleSprite, "self_modulate", Color.RED, flash_time)
	tween.tween_property(BorderCircleSprite, "self_modulate", Color.BLACK, flash_time)
	tween.tween_callback(onFlash)

func onTurnTimerTimeout() -> void:
	InnerCircleSprite.set_instance_shader_parameter("progress", 1.0)
	turn_timer_timeout.emit()
	flashing = false
