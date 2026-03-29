class_name SunnyTriggerStatusEffectAction extends TriggerStatusEffectAction

func _init(_status_effect: StatusEffect) -> void:
	status_effect = _status_effect
	
func onPostAction() -> void:
	status_effect.onSunny()
