class_name CardInfo extends ResourceInfo

enum Rarity {NULL, ONE, TWO, THREE}
@export var type: Data.CardType
@export var rarity: Rarity
@export var gdscript: GDScript

func getRarity() -> Rarity: return rarity
func getType() -> Data.CardType: return type as Data.CardType
func getGdscript() -> GDScript: return gdscript

static func getDefaultPath() -> String: return "res://resources/infos/cards/"
