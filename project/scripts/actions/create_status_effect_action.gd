class_name CreateStatusEffectAction extends Action

var character: Character
var status_effect: StatusEffect
var info: StatusEffectInfo
func _init(_info: StatusEffectInfo, _character: Character)  -> void:
	info = _info
	character = _character
	
func onPreAction() -> void: if character.hasStatusEffect(info): onFailAction(); return
func onPostAction() -> void:
	status_effect = info.getStatusEffect(character)

func isPlayers() -> bool: return character.isPlayers()
func getStatusEffect() -> StatusEffect: return status_effect
func getCharacter() -> Character: return character
func getInfo() -> StatusEffectInfo: return info

func getLogInfo() -> Array:
	return ["Info: %s" % info.getName()]
