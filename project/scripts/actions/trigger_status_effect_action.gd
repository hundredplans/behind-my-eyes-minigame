@abstract class_name TriggerStatusEffectAction extends Action

var status_effect: StatusEffect

@abstract func _init() -> void
func onPreAction() -> void: if status_effect == null: onFailAction()
func getStatusEffect() -> StatusEffect: return status_effect
func getLogInfo() -> Array: return ["Status Effect: %s" % status_effect.getName()]
