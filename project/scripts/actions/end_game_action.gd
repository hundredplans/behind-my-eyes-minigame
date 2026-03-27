class_name EndGameAction extends Action

enum Type {NULL, LOSS, WIN, COLLAB}
var type: Type
func _init(_type: Type) -> void:
	type = _type

func onPreAction() -> void: pass
func onPostAction() -> void:
	pass
	
func getType() -> Type: return type
static func getTypeString(_type: Type) -> String:
	match _type:
		Type.LOSS: return "Loss"
		Type.WIN: return "Win"
		Type.COLLAB: return "Collab"
	return ""
	
func getLogInfo() -> Array:
	return ["Type: %s" % getTypeString(type)]
