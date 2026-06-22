extends Button

var on=false

@onready var ActionSender: ActionManager = %ActionSender

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate=0
	self_modulate=0
	
	var sprite: Sprite2D = get_parent()
	var atlas = sprite.texture as AtlasTexture
	atlas.region.position.x = 416
	
	pass # Replace with function body.
	


func _on_pressed() -> void:
	#sendFilterAction()
	on = !on
	var sprite: Sprite2D = get_parent()
	var atlas = sprite.texture as AtlasTexture
	if on :
		atlas.region.position += Vector2(48,0)
	else:
		atlas.region.position -= Vector2(48,0)
		
		
#func sendFilterAction() ->void :
	#onPush([FilterCardsInCatalogAction.new(name)])
		
func onPush(actions: Array) -> void: ActionSender.onPush(actions)
