extends Screen

@onready var CardSpot: Control = %CardSpot
@onready var PointsDisplay: Node2D = %PointsDisplay
@onready var ActionSender: ActionManager = %ActionSender
@onready var CardsContainer: Container = %CardsContainer

@export var PauseMenuPacked: PackedScene
@export var CardUIPacked: PackedScene

var PauseMenu: Control
func onProcessAction(action: Action) -> void:
	if action.isPost():
		if action is StartGameAction:
			onStartGame()
		elif action is CreateHandCardAction:
			onCreateHandCard(action)
			
func onStartGame() -> void:
	var actions: Array = [DrawCardAction.new(Data.MIN_HAND_SIZE, true)]
	onInitialisePlayer()
	onInitialiseEnemy()
	PointsDisplay.setInfo()
	onPush(actions)
	
func onInitialisePlayer() -> void:
	var player := Character.new()
	player.setInfo(Data.getPlayerStartingDeck(), true)
	Board.setPlayer(player)
	
func onInitialiseEnemy() -> void:
	var enemy := Character.new()
	enemy.setInfo(Data.getEnemyStartingDeck(), false)
	Board.setEnemy(enemy)
	
func onCreateHandCard(action: CreateHandCardAction) -> void:
	var card: Card = action.getCard()
	if !card.isPlayers(): return
	var card_ui: CardUI = CardUIPacked.instantiate()
	CardsContainer.add_child(card_ui)
	card_ui.setDraggable(true)
	card_ui.setCard(card)

func _ready() -> void:
	Actions.process_action.connect(onProcessAction)
	onPush([StartGameAction.new()])

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Escape") and !isPauseMenu():
		onCreatePauseMenu()

func onCreatePauseMenu() -> void:
	PauseMenu = PauseMenuPacked.instantiate()
	add_child(PauseMenu)
	PauseMenu.setInfo()
	
func isPauseMenu() -> bool: return PauseMenu != null
func onPush(actions: Array) -> void: ActionSender.onPush(actions)
