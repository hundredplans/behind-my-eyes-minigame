extends Screen

@onready var PlayCardLineEdit: LineEdit = %PlayCardLineEdit
@onready var AIManager: Node = %AIManager
@onready var CardSpot: Control = %CardSpot
@onready var PointsDisplay: Node2D = %PointsDisplay
@onready var ActionSender: ActionManager = %ActionSender
@onready var HandCardsManager: Node2D = %HandCardsManager

const PLAY_CARD_DELAY: float = 0.5

@export var PauseMenuPacked: PackedScene
@export var CardUIPacked: PackedScene

var PauseMenu: Control
func onProcessAction(action: Action) -> void:
	if action.isPost():
		if action is StartGameAction:
			onStartGame()
		elif action is CreateHandCardAction:
			onCreateHandCard(action)
		elif action is PlayCardAction:
			onPlayCard(action)
		elif action is StartTurnAction and action.isPlayers():
			onStartTurn()
		elif action is TriggerCardEffectsAction:
			onTriggerCardEffects()
			
func onStartGame() -> void:
	var actions: Array = [DrawCardAction.new(Data.MIN_HAND_SIZE, true)]
	onPush(actions)
	
func onStartTurn() -> void:
	pass
	
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
	HandCardsManager.onAddCardUI(card_ui)
	card_ui.setCard(card)
	
func onPlayCard(action: PlayCardAction) -> void:
	var card_ui: CardUI = CardUIPacked.instantiate()
	CardSpot.add_child(card_ui)
	card_ui.setCard(action.getCard())

func _ready() -> void:
	Actions.process_action.connect(onProcessAction)
	Actions.action_chain_started.connect(onActionChainStarted)
	Actions.action_chain_ended.connect(onActionChainEnded)
	onInitialisePlayer()
	onInitialiseEnemy()
	PointsDisplay.setInfo()
	onPush([StartGameAction.new()])

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Escape") and !isPauseMenu():
		onCreatePauseMenu()

func onCreatePauseMenu() -> void:
	PauseMenu = PauseMenuPacked.instantiate()
	add_child(PauseMenu)
	PauseMenu.setInfo()
	
func onActionChainStarted() -> void:
	PlayCardLineEdit.editable = false
	for card_ui: CardUI in getCardUis(): card_ui.setDisabled(true)
	
func onActionChainEnded() -> void:
	PlayCardLineEdit.editable = true
	for card_ui: CardUI in getCardUis(): card_ui.setDisabled(false)
	
func getCardUis() -> Array: return HandCardsManager.getCardUis()
func isPauseMenu() -> bool: return PauseMenu != null
func onPush(actions: Array) -> void: ActionSender.onPush(actions)
func onAppend(actions: Array) -> void: ActionSender.onAppend(actions)

func onPlayCardLineEditTextSubmitted(new_text: String) -> void:
	new_text = new_text.to_lower()
	for card_ui: CardUI in getCardUis():
		if card_ui.getCard().getName().to_lower() != new_text: continue
		onPush([PlayCardAction.new(card_ui.getCard(), card_ui),
			TriggerCardEffectsAction.new()])
		onAppend([DelayAction.new(PLAY_CARD_DELAY), StartTurnAction.new(false)])
		return
		
func onTriggerCardEffects() -> void:
	for card_ui: CardUI in CardSpot.get_children(): card_ui.queue_free()
