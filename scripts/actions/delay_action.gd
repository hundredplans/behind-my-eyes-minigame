class_name DelayAction extends Action

var delay: float
func _init(_delay: float) -> void:
	delay = _delay
	
func onPreAction() -> void: if delay <= 0: onFailAction()
func onPostAction() -> void:
	pass
	
func getLogInfo() -> Array:
	return ["Delay: %s" % delay]
