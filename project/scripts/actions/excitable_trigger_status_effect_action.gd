class_name ExcitableTriggerStatusEffectAction extends TriggerStatusEffectAction

var action: UpdatePointsAction
func _init(_status_effect: StatusEffect, _action: UpdatePointsAction) -> void:
	status_effect = _status_effect
	action = _action
	
func onPostAction() -> void:
	status_effect.onExcitable(action)
