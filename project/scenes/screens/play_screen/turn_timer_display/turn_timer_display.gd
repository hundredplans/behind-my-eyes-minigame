extends Node2D

signal turn_timer_timeout
@onready var ClockAnimatedSprite: AnimatedSprite2D = %ClockAnimatedSprite
@onready var TurnTimer: Timer = %TurnTimer

@export var start_timer_color: Color
@export var end_timer_color: Color
@export var disabled_color: Color

var flashing: bool
var EndTimerAudioStreamPlayer: AudioStreamPlayer

func _ready() -> void:
	Actions.action_chain_started.connect(onDelayTimerStart)
	Actions.action_chain_ended.connect(onDelayTimerEnd)

func onStart() -> void:
	TurnTimer.start(Data.TURN_TIME)
	
func onDelayTimerStart() -> void:
	modulate = disabled_color
	TurnTimer.set_paused(true)
	
func onDelayTimerEnd() -> void:
	modulate = Color.WHITE
	TurnTimer.set_paused(false)

func _process(_delta: float) -> void:
	if TurnTimer.paused: return
	ClockAnimatedSprite.frame = floor(abs((TurnTimer.time_left - Data.TURN_TIME)) / 3)
	
func onTurnTimerTimeout() -> void:
	turn_timer_timeout.emit()
