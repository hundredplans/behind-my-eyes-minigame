class_name CardInfo extends ResourceInfo

enum Rarity {NULL, ONE, TWO, THREE}
@export var type: Data.CardType = Data.CardType.NULL
@export var rarity: Rarity
@export var gdscript: GDScript
@export var tooltips: Array[TooltipData] = []

func getTooltipDatas() -> Array[TooltipData]: return tooltips
func getRarity() -> Rarity: return rarity
func getType() -> Data.CardType: return type as Data.CardType
func getGdscript() -> GDScript: return gdscript
func getCard(players: bool) -> Card: return gdscript.new(self, players)
static func getDefaultPath() -> String: return "res://resources/infos/cards/"
