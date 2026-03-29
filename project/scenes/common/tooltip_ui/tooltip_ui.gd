extends Node2D

@onready var NameLabel: Label = %NameLabel
@onready var IconTxRect: TextureRect = %IconTxRect
func setEntityObject(entity_object: EntityObject) -> void:
	NameLabel.text = entity_object.getName()
	IconTxRect.texture = entity_object.getInfo().getTooltipIcon()
