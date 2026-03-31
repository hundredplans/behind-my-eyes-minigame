extends Node2D

@onready var IconSprite: Sprite2D = %IconSprite
@onready var DisplayAmountLabel: Label = %DisplayAmountLabel
@onready var DefaultTooltipNode: DefaultTooltip = %DefaultTooltipNode
var status_effect: StatusEffect
func setStatusEffect(_status_effect: StatusEffect) -> void:
	status_effect = _status_effect
	var tooltip_data := TooltipData.new()
	tooltip_data.setType(TooltipData.Type.STATUS_EFFECT)
	tooltip_data.setId(status_effect.getInfo().getId())
	DefaultTooltipNode.onUpdateTooltipDatas([tooltip_data])
	IconSprite.texture = status_effect.getInfo().getIcon()
	status_effect.update_display_amount.connect(onUpdateDisplayAmount)
	onUpdateDisplayAmount()
	
func getStatusEffect() -> StatusEffect: return status_effect
	
func onUpdateDisplayAmount() -> void:
	var display_amount: int = status_effect.getDisplayAmount()
	DisplayAmountLabel.text = "" if display_amount < 0 else str(display_amount)
