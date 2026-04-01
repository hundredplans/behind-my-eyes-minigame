extends Node2D

@export var offset: float = 50.0
func onHandCardCreated(card_ui: CardUI) -> void:
	add_child(card_ui)
	onSortCardUis()
	
func onHandCardRemoved() -> void:
	onSortCardUis()
	
func onSortCardUis() -> void:
	var children: Array = getCardUis().filter(func(x: CardUI): return !x.is_queued_for_deletion())
	var amount: int = children.size()
	var step: float = (2 * offset) / (amount - 1)
	for i: int in amount:
		var card_ui: CardUI = children[i]
		card_ui.position.x = -offset + (i * step)
	
func getCardUis() -> Array:
	return get_children()
