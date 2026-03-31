class_name TooltipData extends Resource

enum Type {NULL, CARD, STATUS_EFFECT}
@export var id: int
@export var type: Type = Type.NULL

func getId() -> int: return id
func getType() -> Type: return type

func setId(_id: int) -> void: id = _id
func setType(_type: Type) -> void: type = _type

func getInfo() -> ResourceInfo:
	match type:
		Type.STATUS_EFFECT: return Info.getInfo(StatusEffectInfo, id)
		Type.CARD: return Info.getInfo(CardInfo, id)
	return null
