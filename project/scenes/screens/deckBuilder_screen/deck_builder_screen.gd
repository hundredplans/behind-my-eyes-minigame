extends Node2D

enum Filter {NICE=0, HAPPY=1, SAD=2, ANGRY=3, SARCASTIC=4, ONE=5, TWO=6, THREE=7} 

var CardsCatalog: Array[CardUI]
var DeckCards: Array[CardUI]
var FreeSlots: Array[bool] = [0,0,0,0,0,0,0,0,0,0]

var emotionFilters: Array[int]
var rarityFilters: Array[int]

var settings_data: SettingsData

@onready var CardAmountLabel: Label =%CardsAmountLabel
@export var CardUIPacked: PackedScene
@onready var CatalogGrid :GridContainer = %GridContainer
@onready var ActionSender: ActionManager = %ActionSender
@onready var SlotUis: Node2D =%CardSlots
@onready var CostLabel: Label =%CostLabel
@onready var Warning: Sprite2D =%Warning

@onready var ButtonNICE: Button =%NICE
@onready var ButtonHAPPY: Button =%HAPPY
@onready var ButtonANGRY: Button =%ANGRY
@onready var ButtonSAD: Button =%SAD
@onready var ButtonSARCASTIC: Button =%SARCASTIC
@onready var ButtonONE: Button =%ONE
@onready var ButtonTWO: Button =%TWO
@onready var ButtonTHREE: Button =%THREE

var CardClicked: CardUI
var maxDeckCost: int = 20
var DeckSize: int = 10

func onUpdateSettings() -> void:
	if !FileAccess.file_exists(SettingsData.getDefaultPath()):
		settings_data = SettingsData.new()
		ResourceSaver.save(settings_data, SettingsData.getDefaultPath())
	else: 
		settings_data = load(SettingsData.getDefaultPath())
		for card in settings_data.DeckCards:
			print(CardsCatalog.size())
			CardsCatalog[card-1].get_child(1).pressed.emit()
		
		
		
func _ready() -> void:
	Actions.process_action.connect(onProcessAction)
	for id in range(1,30):
		var card_info: CardInfo = Info.getInfo(CardInfo, id)
		var card: Card = card_info.getCard(false)
		makeCardUi(card)
	CostLabel.text= str(getCurrentCost()) +"/20"  
	CardAmountLabel.text= str(getCurrentDeckSize()) +"/10"  
	
	ButtonNICE.pressed.connect(sendFilterAction.bind(2))
	ButtonHAPPY.pressed.connect(sendFilterAction.bind(4))
	ButtonANGRY.pressed.connect(sendFilterAction.bind(1))
	ButtonSAD.pressed.connect(sendFilterAction.bind(3))
	ButtonSARCASTIC.pressed.connect(sendFilterAction.bind(5))
	ButtonONE.pressed.connect(sendFilterAction.bind(6))
	ButtonTWO.pressed.connect(sendFilterAction.bind(7))
	ButtonTHREE.pressed.connect(sendFilterAction.bind(8))
	onUpdateSettings()



func onProcessAction(action: Action) -> void:
	if action.isPost():
		if action is PutCardInDeckAction:
			onPutCardInDeck(action)
		elif action is RemoveCardFromDeckAction:
			onRemoveCardFromDeck(action)
		elif action is FilterCardsInCatalogAction:
			onFilterCardsInCatalogAction(action)


 #Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		CardsCatalog.clear()
		if DeckCards.size()==10:
			var DeckIds: Array[int]
			for card in DeckCards:
				DeckIds.append(card.card.getInfo().getId())
			
			settings_data.DeckCards = DeckIds
			ResourceSaver.save(settings_data, SettingsData.getDefaultPath())
			
		else:
			Warning.visible=true


func makeCardUi(card: Card) -> void:
	var card_ui: CardUI = CardUIPacked.instantiate()
	var Controlnode = Control.new()
	Controlnode.add_child(card_ui)
	CatalogGrid.add_child(Controlnode)
	card_ui.setCard(card)
	card_ui.deckBuilder=true
	var button: Button = Button.new()
	card_ui.add_child(button)
	CardsCatalog.append(card_ui)
	button.size=card_ui.atlas.get_size()
	button.position=card_ui.position-card_ui.atlas.get_size()/2
	button.pressed.connect(sendPutAction.bind(button))
	button.self_modulate=0
	button.modulate=0
	

func sendPutAction(button: Button) -> void:
	button.pressed.disconnect(sendPutAction.bind(button))
	button.pressed.connect(sendRemoveAction.bind(button))
	
	var cardUi: CardUI = button.get_parent()
	onPush([PutCardInDeckAction.new(cardUi, getCurrentCost(),getCurrentDeckSize())])
	return
	
func sendRemoveAction(button: Button) -> void:

	button.pressed.disconnect(sendRemoveAction.bind(button))
	button.pressed.connect(sendPutAction.bind(button))
	var cardUi: CardUI = button.get_parent()
	print(cardUi.NameLabel.text)
	onPush([RemoveCardFromDeckAction.new(cardUi)])
	return

func sendFilterAction(filter: int) -> void:		
	if filter<=5:
		if !emotionFilters.has(filter):
			emotionFilters.append(filter)
		else:
			emotionFilters.erase(filter)
	else:
		if !rarityFilters.has(filter-5):
			rarityFilters.append(filter-5)
		else:
			rarityFilters.erase(filter-5)
	for card in CardsCatalog:
		var matches_type = emotionFilters.has(card.getCard().getInfo().getType()) or emotionFilters.is_empty()
		var matches_rarity = rarityFilters.has(card.getCard().getInfo().getRarity()) or rarityFilters.is_empty()
		if !card.inDeck:
			card.get_parent().visible = matches_type and matches_rarity 
	
	#onPush([PutCardInDeckAction.new(action.card)])
func onPutCardInDeck(action: PutCardInDeckAction) -> void:
	Warning.visible=false
	var UINode: CardUI = action.card	
	
	var control: Control = UINode.get_parent()
	var global_pos = control.global_position
	
	control.get_parent().remove_child(control)
	
	UINode.inDeck=true
	DeckCards.append(UINode)
	var spot: int =getFirstFreeSlot()
	UINode.deckSlot=spot
	FreeSlots[spot]=true
	SlotUis.get_child(spot).add_child(control)
	CostLabel.text= str(getCurrentCost()) +"/20" 
	CardAmountLabel.text= str(getCurrentDeckSize()) +"/10"   

	
	UINode.deckSlot=spot
	control.global_position = SlotUis.get_child(spot).global_position
	
	

func onRemoveCardFromDeck(action: RemoveCardFromDeckAction) -> void:
	
	var UINode: CardUI = action.card
	UINode.get_parent().get_parent().remove_child(UINode.get_parent())
	UINode.inDeck=false
	DeckCards.erase(UINode)
	
	var spot: int =getFirstFreeSlot()
	FreeSlots[UINode.deckSlot]=false
	UINode.deckSlot =-1
	
	CatalogGrid.add_child(UINode.get_parent())
	CostLabel.text= str(getCurrentCost()) +"/20"  
	CardAmountLabel.text= str(getCurrentDeckSize()) +"/10"  
	
func onFilterCardsInCatalogAction(action: FilterCardsInCatalogAction) -> void:
	pass

	
func getFirstFreeSlot() -> int:
	return FreeSlots.find(false)
	
func getCurrentDeckSize() -> int :
	return DeckCards.size()
	

	
func getFreeSlots() -> Array[bool]:
	return FreeSlots
	
func getCurrentCost() -> int:
	var cost: int = 0
	for card in DeckCards:
		cost += card.card.getInfo().rarity
	return cost

func getCardUis() -> Array: return CardsCatalog
func onPush(actions: Array) -> void: ActionSender.onPush(actions)
func onAppend(actions: Array) -> void: ActionSender.onAppend(actions)
