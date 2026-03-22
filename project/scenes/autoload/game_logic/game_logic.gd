extends Node

var type_to_type: Dictionary = { # Data.CardType: Dictionary[Data.CardType, ]
	Data.CardType.ANGRY: {
			Data.CardType.ANGRY: Data.PointType.WIN,
			Data.CardType.KIND: Data.PointType.WIN,
			Data.CardType.SAD: Data.PointType.WIN,
			Data.CardType.HAPPY: Data.PointType.WIN,
			Data.CardType.SARCASTIC: Data.PointType.WIN,
	},
	Data.CardType.KIND: {
			Data.CardType.ANGRY: Data.PointType.COLLAB,
			Data.CardType.KIND: Data.PointType.COLLAB,
			Data.CardType.SAD: Data.PointType.COLLAB,
			Data.CardType.HAPPY: Data.PointType.COLLAB,
			Data.CardType.SARCASTIC: Data.PointType.NONE,
	},
	Data.CardType.SAD: {
			Data.CardType.ANGRY: Data.PointType.LOSE,
			Data.CardType.KIND: Data.PointType.NONE,
			Data.CardType.SAD: Data.PointType.WIN,
			Data.CardType.HAPPY: Data.PointType.WIN,
			Data.CardType.SARCASTIC: Data.PointType.NONE,
	},
	Data.CardType.HAPPY: {
			Data.CardType.ANGRY: Data.PointType.NONE,
			Data.CardType.KIND: Data.PointType.COLLAB,
			Data.CardType.SAD: Data.PointType.COLLAB,
			Data.CardType.HAPPY: Data.PointType.COLLAB,
			Data.CardType.SARCASTIC: Data.PointType.NONE,
	},
	Data.CardType.SARCASTIC: {
			Data.CardType.ANGRY: Data.PointType.WIN,
			Data.CardType.KIND: Data.PointType.NONE,
			Data.CardType.SAD: Data.PointType.WIN,
			Data.CardType.HAPPY: Data.PointType.WIN,
			Data.CardType.SARCASTIC: Data.PointType.COLLAB,
	},
}
func getMatchType(type: Data.CardType, type_tuah: Data.CardType) -> Data.PointType:
	return type_to_type[type][type_tuah]
