class_name CardInfo extends ResourceInfo

@export var type: int
@export var gdscript: GDScript

func getType() -> Data.CardType: return type as Data.CardType
func getGdscript() -> GDScript: return gdscript

static func getDefaultPath() -> String: return "res://resources/infos/cards/"
