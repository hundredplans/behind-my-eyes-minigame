extends Screen

@onready var CardsContainer: Container = %CardsContainer
@export var PauseMenuPacked: PackedScene
@export var CardUIPacked: PackedScene
@export var deck: Array[DeckCard]

var PauseMenu: Control
func _ready() -> void:
	for deck_card: DeckCard in deck:
		var card := deck_card.getCard()
		var card_ui: CardUI = CardUIPacked.instantiate()
		CardsContainer.add_child(card_ui)
		card_ui.setInfo(card)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Escape") and !isPauseMenu():
		onCreatePauseMenu()

func onCreatePauseMenu() -> void:
	PauseMenu = PauseMenuPacked.instantiate()
	add_child(PauseMenu)
	PauseMenu.setInfo()
	
func isPauseMenu() -> bool: return PauseMenu != null
