class_name RemoveStatusEffectAction extends Action

var info: StatusEffectInfo
var character: Character
func _init(_info: StatusEffectInfo, _character: Character) -> void:
	info = _info
	character = _character
	
func onPreAction() -> void:
	if !character.hasStatusEffect(info): onFailAction()
	
func onPostAction() -> void:
	pass
	
func getInfo() -> StatusEffectInfo: return info
func getCharacter() -> Character: return character
func getLogInfo() -> Array:
	return ["Status Effect Name: %s" % info.getName(), "Character: %s" % character.getName()]
