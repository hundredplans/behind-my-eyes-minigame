class_name StartGameAction extends Action

func onPreAction() -> void: pass
func onPostAction() -> void:
	onPush([StartTurnAction.new(false)])
	
func getLogInfo() -> Array: return []
