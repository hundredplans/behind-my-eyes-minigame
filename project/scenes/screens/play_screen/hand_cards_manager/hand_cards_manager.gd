extends Node2D

func onAddCardUI(card_ui: CardUI) -> void:
	add_child(card_ui)
	
func getCardUis() -> Array:
	return get_children()
