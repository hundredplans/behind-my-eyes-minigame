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
		#card_ui.rotation= -0.1 + 0.10*i
		card_ui.z_index= 14 - 2*i 
		#card_ui.position.y = +2 *i 
		card_ui.position.x = -offset + (i * step)
	
func getCardUis() -> Array:
	return get_children()

var ScaleTween: Tween
	
#func onScale(scaleUp :bool) -> void:
	#var children = getCardUis()
	#
	#if ScaleTween: ScaleTween.kill()
	#ScaleTween = create_tween()
	#if scaleUp:
		#ScaleTween.parallel().tween_property(self, "scale",Vector2(1.25,1.25),0.2)
		#ScaleTween.parallel().tween_property(self, "position", Vector2(-25,5), 0.2)
	#
	#else:
		#ScaleTween.parallel().tween_property(self, "scale",Vector2(1.0,1.0),0.2)
		#ScaleTween.parallel().tween_property(self, "position", Vector2(0,0), 0.2)
	#
	#ScaleTween.finished.connect(onScale)	
