extends Node2D

@onready var TurnsSprite: Sprite2D = %TurnsSprite
@onready var IconSprite: Sprite2D = %IconSprite
@onready var DisplayAmountLabel: Label = %DisplayAmountLabel
@onready var DefaultTooltipNode: DefaultTooltip = %DefaultTooltipNode

@export var start_animation_time: float = 0.5
@export var death_animation_time: float = 0.5
@export var triggered_delay: float = 0.6
@export var triggered_color: Color
@export var triggered_extra_scale := Vector2(0.1, 0.1)

var NTriggeredTween: Tween
var TriggeredTween: Tween
var status_effect: StatusEffect
var first_load: bool
func setStatusEffect(_status_effect: StatusEffect) -> void:
	status_effect = _status_effect
	var tooltip_data := TooltipData.new()
	tooltip_data.setType(TooltipData.Type.STATUS_EFFECT)
	tooltip_data.setId(status_effect.getInfo().getId())
	DefaultTooltipNode.onUpdateTooltipDatas([tooltip_data])
	IconSprite.texture = status_effect.getInfo().getIcon()
	status_effect.update_display_amount.connect(onUpdateDisplayAmount)
	status_effect.triggered.connect(onStatusEffectTriggered)
	onStartAnimation()
	onUpdateDisplayAmount()
	
func getStatusEffect() -> StatusEffect: return status_effect
	
func onUpdateDisplayAmount() -> void:
	var display_amount: int = status_effect.getDisplayAmount()
	DisplayAmountLabel.text = "" if display_amount < 0 else str(display_amount)
	TurnsSprite.visible = display_amount >= 0

func onStartAnimation() -> void:
	if TriggeredTween: TriggeredTween.kill()
	if NTriggeredTween: NTriggeredTween.kill()
	
	scale = Vector2.ZERO
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, start_animation_time).as_relative().set_trans(Tween.TRANS_SINE)

func onDeath() -> void:
	if TriggeredTween: TriggeredTween.kill()
	if NTriggeredTween: NTriggeredTween.kill()
	
	var tween := create_tween()
	tween.tween_property(self, "scale", -scale, death_animation_time).as_relative().set_trans(Tween.TRANS_SINE)
	await tween.finished
	queue_free()
	
func onStatusEffectTriggered() -> void:
	var delay: float = triggered_delay / 3.0
	if TriggeredTween: TriggeredTween.kill()
	TriggeredTween = create_tween()
	TriggeredTween.tween_property(self, "modulate", triggered_color, delay)
	TriggeredTween.tween_interval(delay)
	TriggeredTween.tween_property(self, "modulate", Color.WHITE, delay)
	
	if NTriggeredTween: NTriggeredTween.kill()
	NTriggeredTween = create_tween()
	NTriggeredTween.tween_property(self, "scale", triggered_extra_scale, delay).as_relative().set_trans(Tween.TRANS_SINE)
	NTriggeredTween.tween_interval(delay)
	NTriggeredTween.tween_property(self, "scale", -triggered_extra_scale, delay).as_relative().set_trans(Tween.TRANS_SINE)
