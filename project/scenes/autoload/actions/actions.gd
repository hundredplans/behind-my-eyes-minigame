extends Node

signal action_chain_started
signal action_chain_ended
signal process_action
var active_action: Action
var actions: Array
func onPush(_actions: Array, _owner: ActionManager) -> void:
	for action: Action in _actions:
		action.setActionOwner(_owner)
		
	_actions += actions
	actions = _actions
	onStartActionChain()

# [StartGame, StartTurn] 
# [StartTurn]
# [DrawCard, DrawCard, DrawCard, StartTurn] PUSH
# [StartTurn, DrawCard, DrawCard, DrawCard] # APPEND
# 

func onAppend(_actions: Array, _owner: ActionManager) -> void:
	for action: Action in _actions:
		action.setActionOwner(_owner)
	actions += _actions
	onStartActionChain()

func onForce(new_actions: Array, _owner: ActionManager) -> void:
	for action: Action in new_actions:
		action.setActionOwner(_owner)
		onAction(action, true)

func onStartActionChain() -> void:
	if active_action != null or actions.is_empty(): return
	action_chain_started.emit()
	onActionChain()

func onActionChain() -> void:
	if active_action != null: return
	if actions.is_empty(): action_chain_ended.emit(); return
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
