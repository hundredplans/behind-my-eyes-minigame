class_name StatusEffectInfo extends ResourceInfo

enum Type {NULL, OTHER, DOUBLER, NULLIFIER}
@export var icon: AtlasTexture
@export var gdscript: GDScript
@export var card_type: Data.CardType
@export var type: Type
func getIcon() -> AtlasTexture: return icon
func getGdscript() -> GDScript: return gdscript
func getCardType() -> Data.CardType: return card_type
func getType() -> Type: return type
func getStatusEffect(character: Character) -> StatusEffect:
	return gdscript.new(self, character)

static func getDefaultPath() -> String: return "res://resources/infos/status_effects/"
