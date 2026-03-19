class_name ActionManager extends Node

var connected: bool # debug var
func onConnectToActions() -> void:
	Actions.process_action.connect(onProcessAction)
	connected = true
	
func onDisconnectFromActions() -> void:
	Actions.process_action.disconnect(onProcessAction)
	connected = false
	
@warning_ignore("unused_parameter")
func onProcessAction(action: Action) -> void: pass

func onPush(actions: Array) -> void:
	if actions.is_empty(): return
	Actions.onPush(actions, self)
	
func onAppend(actions: Array) -> void:
	if actions.is_empty(): return
	Actions.onAppend(actions, self)

func onForce(actions: Array) -> void:
	if actions.is_empty(): return
	Actions.onForce(actions, self)
