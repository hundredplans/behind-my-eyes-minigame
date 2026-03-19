extends Node

signal process_action
var active_action: Action
var actions: Array
func onPush(_actions: Array, _owner: ActionManager) -> void:
	for action: Action in _actions:
		action.setOwner(_owner)
		
	_actions += actions
	actions = _actions
	onActionChain()

func onAppend(_actions: Array, _owner: ActionManager) -> void:
	for action: Action in _actions:
		action.setOwner(_owner)
	actions += _actions
	onActionChain()

func onForce(new_actions: Array, _owner: ActionManager) -> void:
	for action: Action in new_actions:
		action.setOwner(_owner)
		onAction(action, true)

func onActionChain() -> void:
	if active_action != null or actions.is_empty(): return
	active_action = actions.pop_front()
	await onAction(active_action, false)
	onFinishActionChain()
	
func onAction(action: Action, forced: bool) -> void:
	if onActionFailed(action, forced): return
	action.onPreAction()
	if onActionFailed(action, forced): return
	process_action.emit(action)
	if onActionFailed(action, forced): return
	action.onPostAction()
	action.post = true
	
	if action is DelayAction:
		await get_tree().create_timer(action.getDelay() / Settings.getSettingsData().getGameSpeed()).timeout
	process_action.emit(action)
	onPrintDebug(action)
	
func onFinishActionChain() -> void:
	active_action = null
	onActionChain()
	
func onActionFailed(action: Action, forced: bool) -> bool:
	if action.failed:
		print(action.get_script().get_global_name() + ": Failed")
		if !forced:
			onFinishActionChain()
		return true
	return false

func onPrintDebug(action: Action) -> void:
	print(action.getDebug())
	for log_name: String in action.getLogInfo():
		print("	%s" % log_name)

func onClearActionChain() -> void:
	actions = []
