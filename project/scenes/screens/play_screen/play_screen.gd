extends Screen

@onready var TurnTimerDisplay: Node2D = %TurnTimerDisplay
@onready var PlayerCardPath: Path2D = %PlayerCardPath
@onready var EnemyCardPath: Path2D = %EnemyCardPath
@onready var EnemyHandCardsManager: Node2D = %EnemyHandCardsManager
@onready var PlayCardLineEdit: LineEdit = %PlayCardLineEdit
@onready var AIManager: Node = %AIManager
@onready var CardSpot: Node2D = %CardSpot
@onready var PointsDisplay: Node2D = %PointsDisplay
@onready var ActionSender: ActionManager = %ActionSender
@onready var HandCardsManager: Node2D = %HandCardsManager

const CARD_TRIGGERED_DISPLAY_END_SCALE: float = 2.0

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
			onTriggerCardEffects(action)
		elif action is CreateHandCardAction and !action.getCard().isPlayers():
			onCreateEnemyHandCard()
		elif action is EndGameAction:
			onEndGame(action)
			
func onStartGame() -> void:
	var actions: Array = [DrawCardAction.new(Data.MIN_HAND_SIZE, true)]
	onPush(actions)
	
func onStartTurn() -> void:
	TurnTimerDisplay.onStart()
	
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
	HandCardsManager.onHandCardCreated(card_ui)
	card_ui.setCard(card)
	card_ui.onCreateHandCard()
	
func onPlayCard(action: PlayCardAction) -> void:
	var card_ui: CardUI = CardUIPacked.instantiate()
	CardSpot.add_child(card_ui)
	card_ui.setCard(action.getCard())
	
	if !action.getCard().isPlayers(): EnemyHandCardsManager.onUpdateAmount()
	else: HandCardsManager.onHandCardRemoved()

func _ready() -> void:
	Actions.process_action.connect(onProcessAction)
	Actions.action_chain_started.connect(onActionChainStarted)
	Actions.action_chain_ended.connect(onActionChainEnded)
	TurnTimerDisplay.turn_timer_timeout.connect(onTurnTimerTimeout)
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
		onCardPlayed(card_ui.getCard())
		return
	
func onCardPlayed(card: Card) -> void:
	onPush([PlayCardAction.new(card), TriggerCardEffectsAction.new()])
	onAppend([StartTurnAction.new(false)])
	
func onTurnTimerTimeout() -> void:
	onCardPlayed(Board.getCharacter(true).getHandCards().pick_random()) # This will break if no cards
	
func onTriggerCardEffects(action: TriggerCardEffectsAction) -> void:
	var field_card_uis: Array = getFieldCardUis()
	assert(field_card_uis.size() == 2, "Invalid field size")
	for card_ui: CardUI in field_card_uis:
		onCardTriggeredDisplay(card_ui, action.getTravelDelay())
	await get_tree().create_timer(action.getTravelDelay()).timeout
	for i: int in field_card_uis.size():
		var card_ui: CardUI = field_card_uis[i]
		var other_card_ui: CardUI = field_card_uis[abs(i - 1)]
		card_ui.setDisabled(false)
		other_card_ui.setDisabled(true)
		await get_tree().create_timer(action.getFlashDelay() / 2.0).timeout
		
	for card_ui: CardUI in field_card_uis: card_ui.queue_free()
	
func onCardTriggeredDisplay(card_ui: CardUI, travel_delay: float) -> void:
	card_ui.setDisabled(true)
	var path: Path2D = (PlayerCardPath if card_ui.getCard().isPlayers() else EnemyCardPath)
	var tween: Tween = create_tween()
	tween.tween_method(onCardTriggeredDisplayTween.bind(path, card_ui), 0.0, 1.0, travel_delay)
	
func onCardTriggeredDisplayTween(p: float, path: Path2D, card_ui: CardUI) -> void:
	var curve: Curve2D = path.curve
	var length: float = curve.get_baked_length()
	var distance: float = length * p
	card_ui.transform = curve.sample_baked_with_rotation(distance)
	card_ui.position += path.position
	var end_scale: float = lerp(1.0, CARD_TRIGGERED_DISPLAY_END_SCALE, p)
	card_ui.scale = Vector2(end_scale, end_scale)
	
func getFieldCardUis() -> Array: return CardSpot.get_children()
	
func onCreateEnemyHandCard() -> void:
	EnemyHandCardsManager.onUpdateAmount()

func onEndGame(action: EndGameAction) -> void:
	match action.getType():
		EndGameAction.Type.LOSS: load_screen.emit(Screen.Type.LOSS)
		EndGameAction.Type.WIN: load_screen.emit(Screen.Type.WIN)
		EndGameAction.Type.COLLAB: load_screen.emit(Screen.Type.COLLAB)
