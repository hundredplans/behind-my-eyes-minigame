extends Node

enum CardType {NULL, ANGRY, NICE, SAD, HAPPY, SARCASTIC}
func getColorFromCardType(card_type: CardType) -> Color:
	match card_type:
		CardType.ANGRY: return Color.RED
		CardType.NICE: return Color.GREEN
		CardType.SAD: return Color.BLUE
		CardType.HAPPY: return Color.YELLOW
		CardType.SARCASTIC: return Color.PURPLE
	return Color.WHITE
