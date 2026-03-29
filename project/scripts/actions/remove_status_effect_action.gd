class_name RemoveStatusEffectAction extends Action

var info: StatusEffectInfo
var character: Character
var status_effect: StatusEffect
func _init(_info: StatusEffectInfo, _character: Character) -> void:
	info = _info
	character = _character
	
func onPreAction() -> void:
	if !character.hasStatusEffect(info): onFailAction()
	
func onPostAction() -> void:
	status_effect = character.getStatusEffect(info)
	onPush([DestroyEntityObjectAction.new(status_effect)])
	
func getInfo() -> StatusEffectInfo: return info
func isPlayers() -> bool: return character.isPlayers()
func getCharacter() -> Character: return character
func getStatusEffect() -> StatusEffect: return status_effect
func getLogInfo() -> Array:
	return ["Status Effect Name: %s" % info.getName(), "Character: %s" % character.getName()]
