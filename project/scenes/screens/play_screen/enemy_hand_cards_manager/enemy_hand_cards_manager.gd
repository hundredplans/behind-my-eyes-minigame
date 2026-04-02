extends Node2D

@onready var CardSprites: Node2D = %CardSprites
@export var EnemyHandCardSprite: PackedScene
func onUpdateAmount() -> void:
	var amount: int = Board.getCharacter(false).getHandCards().size()
	var child_amount: int = CardSprites.get_child_count()
	if amount == child_amount: return
	
	if amount > child_amount:
		for __: int in amount - child_amount:
			var enemy_hand_card_sprite: Sprite2D = EnemyHandCardSprite.instantiate()
			CardSprites.add_child(enemy_hand_card_sprite)
	elif amount < child_amount:
		for i: int in child_amount - amount:
			CardSprites.get_child(child_amount - i - 1).queue_free()
			
	
