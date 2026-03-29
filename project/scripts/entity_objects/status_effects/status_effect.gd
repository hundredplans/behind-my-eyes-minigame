class_name StatusEffect extends EntityObject

signal update_display_amount
var character: Character
func _init(_info: ResourceInfo, _character: Character) -> void:
	super(_info)
	character = _character
	onConnectToActions()
	onStatusEffectCreated()
	
func onProcessAction(action: Action) -> void:
	if !action.isPost():
		if action is UpdatePointsAction and action.isPlayers() == isPlayers():
			if isDoubler():
				onForce([DoublerTriggerStatusEffectAction.new(self, action)])
			elif isNullifier():
				onForce([NullifierTriggerStatusEffectAction.new(self, action)])

func onDoubler(action: UpdatePointsAction) -> void: action.onDouble()
func onNullifier(action: UpdatePointsAction) -> void: action.onNullify()
func onStatusEffectCreated() -> void: pass
	
func isPlayers() -> bool: return character.isPlayers()
func isDoubler() -> bool: return info.getType() == StatusEffectInfo.Type.DOUBLER
func isNullifier() -> bool: return info.getType() == StatusEffectInfo.Type.NULLIFIER
	
func onUpdateDisplayAmount() -> void: update_display_amount.emit()
func getDisplayAmount() -> int: return -1
func getInfo() -> StatusEffectInfo: return info
