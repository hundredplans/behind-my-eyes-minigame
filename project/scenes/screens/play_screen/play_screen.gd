extends Screen

@onready var EnemyWordLabel: Label = %EnemyWordLabel
@onready var EnemySpeechBubble: Node2D = %EnemySpeechBubble
@onready var TestPath: Path2D = %TestPath
@onready var TurnTimerDisplay: Node2D = %TurnTimerDisplay
@onready var EnemyHandCardsManager: Node2D = %EnemyHandCardsManager
@onready var PlayCardLineEdit: LineEdit = %PlayCardLineEdit
@onready var AIManager: Node = %AIManager
@onready var Blink: AnimatedSprite2D = %Blink
@onready var CardSpot: Node2D = %CardSpot
@onready var PointsDisplay: Node2D = %PointsDisplay
@onready var ActionSender: ActionManager = %ActionSender
@onready var HandCardsManager: Node2D = %HandCardsManager

const CARD_TRIGGERED_DISPLAY_END_SCALE: float = 2.0

@export var card_trigger_curve: Curve2D
@export var PauseMenuPacked: PackedScene
@export var CardUIPacked: PackedScene

@export var enemy_speech_bubble_start_position: Vector2
@export var enemy_speech_bubble_end_position: Vector2

@export var gain_collab_point_sfx: AudioStream
@export var gain_point_sfx: AudioStream
@export var lose_point_sfx: AudioStream
@export var turn_start_sfx: AudioStream
@export var card_triggered_sfx: AudioStream

var card_trigger_mirror_curve: Curve2D
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
		elif action is UpdatePointsAction:
			onUpdatePoints(action)
		elif action is TriggerCardAction:
			onTriggerCard()
			
func onStartGame() -> void:
	var actions: Array = [DrawCardAction.new(Data.MIN_HAND_SIZE, true)]
	onPush(actions)
	
func onTriggerCard() -> void:
	Audio.onPlaySFX(card_triggered_sfx)
	
func onStartTurn() -> void:
	Audio.onPlaySFX(turn_start_sfx)
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
	card_ui.skew = deg_to_rad(-43)
	card_ui.rotation = deg_to_rad(-25)
	CardSpot.add_child(card_ui)
	
	card_ui.setCard(action.getCard())
	card_ui.setTooltipSelf(true)
	
	if !action.getCard().isPlayers():
		EnemyHandCardsManager.onUpdateAmount()
		onCreateEnemySpeechBubble(action.getCard(), action.getEnemyPlayCardDelay())
		card_ui.setZIndex(50)
	else: HandCardsManager.onHandCardRemoved()

func _ready() -> void:
	EnemySpeechBubble.visible = false
	Blink.visible = true
	Blink.play("OpenEyes")
	Actions.process_action.connect(onProcessAction)
	Actions.action_chain_started.connect(onActionChainStarted)
	Actions.action_chain_ended.connect(onActionChainEnded)
	TurnTimerDisplay.turn_timer_timeout.connect(onTurnTimerTimeout)
	onInitialisePlayer()
	onInitialiseEnemy()
	PointsDisplay.setInfo()
	onPush([StartGameAction.new()])
	setMirroredCardTriggerCurve()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Escape") and !isPauseMenu():
		onCreatePauseMenu()

func onCreatePauseMenu() -> void:
	Blink.visible=true
	Blink.play("CloseEyes")
	PauseMenu = PauseMenuPacked.instantiate()
	
func onActionChainStarted() -> void:
	PlayCardLineEdit.setActionChained(true)
	for card_ui: CardUI in getCardUis(): card_ui.setDisabled(true)
	
func onActionChainEnded() -> void:
	PlayCardLineEdit.setActionChained(false)
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
		PlayCardLineEdit.onTextValid()
		return
	PlayCardLineEdit.onTextInvalid()
	
func onCardPlayed(card: Card) -> void:
	onPush([PlayCardAction.new(card), TriggerCardEffectsAction.new()])
	onAppend([StartTurnAction.new(false)])
	
func onTurnTimerTimeout() -> void:
	onCardPlayed(Board.getCharacter(true).getHandCards().pick_random()) # This will break if no cards
	
func onTriggerCardEffects(action: TriggerCardEffectsAction) -> void:
	var field_card_uis: Array = action.getFieldCards().map(func(x: Card): return getFieldCardUI(x))
	assert(field_card_uis.size() == 2, "Invalid field size")
	for card_ui: CardUI in field_card_uis:
		onCardTriggeredDisplay(card_ui, action.getTravelDelay())
	await get_tree().create_timer(action.getTravelDelay()).timeout
	var flash_delay: float = action.getFlashDelay() / 2.0
	
	for card_ui: CardUI in field_card_uis:
		card_ui.setMouseFilter(Control.MOUSE_FILTER_IGNORE)
	
	for i: int in field_card_uis.size():
		var card_ui: CardUI = field_card_uis[i]
		var other_card_ui: CardUI = field_card_uis[abs(i - 1)]
		var point_type: Data.PointType = GameLogic.getMatchType(card_ui.getCard().getCardType(), other_card_ui.getCard().getCardType())
		card_ui.onCardTriggeredDisplay(point_type)
		card_ui.setDisabled(false)
		other_card_ui.setDisabled(true)
		await get_tree().create_timer(flash_delay).timeout
	
	var destroy_delay: float = action.getDestroyDelay()
	var end_scale: float = CARD_TRIGGERED_DISPLAY_END_SCALE
	for card_ui: CardUI in field_card_uis:
		var tween := create_tween()
		tween.tween_property(card_ui, "rotation", PI * 2, destroy_delay).as_relative()
		
		var ntween := create_tween()
		ntween.tween_property(card_ui, "scale", -Vector2(end_scale, end_scale), destroy_delay)\
			.as_relative().set_trans(Tween.TRANS_SINE)
		ntween.finished.connect(func(): card_ui.queue_free())
	
func onCardTriggeredDisplay(card_ui: CardUI, travel_delay: float) -> void:
	card_ui.onCardTriggeredTravel()
	var players: bool = card_ui.getCard().isPlayers()
	var curve: Curve2D = (card_trigger_mirror_curve if players else card_trigger_curve)
	var tween: Tween = create_tween()
	tween.tween_method(onCardTriggeredDisplayTween.bind(curve, card_ui), 0.0, 1.0, travel_delay)
	
func onCardTriggeredDisplayTween(p: float, curve: Curve2D, card_ui: CardUI) -> void:
	var length: float = curve.get_baked_length()
	var distance: float = length * p
	card_ui.transform = curve.sample_baked_with_rotation(distance)
	if card_ui.getCard().isPlayers(): card_ui.rotation += PI
	
	var end_scale: float = lerp(1.0, CARD_TRIGGERED_DISPLAY_END_SCALE, p)
	card_ui.scale = Vector2(end_scale, end_scale)
	
func getFieldCardUis() -> Array: return CardSpot.get_children()
func getFieldCardUI(card: Card) -> CardUI:
	for card_ui: CardUI in getFieldCardUis():
		if card_ui.getCard() == card: return card_ui
	return null
func onCreateEnemyHandCard() -> void:
	EnemyHandCardsManager.onUpdateAmount()

func onEndGame(action: EndGameAction) -> void:
	match action.getType():
		EndGameAction.Type.LOSS: load_screen.emit(Screen.Type.LOSS)
		EndGameAction.Type.WIN: load_screen.emit(Screen.Type.WIN)
		EndGameAction.Type.COLLAB: load_screen.emit(Screen.Type.COLLAB)

func _on_blink_animation_finished() -> void:
	if isPauseMenu():
		add_child(PauseMenu)
		PauseMenu.load_screen.connect(on_leave)
	Blink.visible=false
	
func on_leave(type: Screen.Type) -> void:
		load_screen.emit(type)
		
func setMirroredCardTriggerCurve() -> void:
	card_trigger_mirror_curve = Curve2D.new()
	var points: PackedVector2Array = card_trigger_curve.get_baked_points()
	for point: Vector2 in points:
		card_trigger_mirror_curve.add_point(Vector2(-point.x, point.y))

func onCreateEnemySpeechBubble(card: Card, delay: float) -> void:
	EnemyWordLabel.text = card.getName()
	EnemyWordLabel.modulate = Data.getColorFromCardType(card.getCardType())
	EnemySpeechBubble.visible = true
	EnemySpeechBubble.scale = Vector2.ZERO
	EnemySpeechBubble.rotation = 0.0
	EnemySpeechBubble.position = enemy_speech_bubble_start_position
	
	var first_delay: float = delay / 8.0 * 2
	var hold_delay: float = (delay / 8.0) * 3
	var dissapear_delay: float = (delay / 8.0) * 2
	var end_delay: float = (delay / 8.0)
	
	var tween := create_tween()
	tween.tween_property(EnemySpeechBubble, "scale", Vector2.ONE, first_delay)\
		.as_relative().set_trans(Tween.TRANS_SINE)
	
	var ntween := create_tween()
	ntween.tween_property(EnemySpeechBubble, "position", enemy_speech_bubble_end_position, first_delay)
	ntween.tween_interval(hold_delay)
	await ntween.finished
	
	var mtween := create_tween()
	mtween.set_parallel(true)
	mtween.tween_property(EnemySpeechBubble, "rotation", PI, dissapear_delay)\
		.as_relative().set_trans(Tween.TRANS_SINE)
	mtween.tween_property(EnemySpeechBubble, "scale", -Vector2.ONE, dissapear_delay)\
		.as_relative().set_trans(Tween.TRANS_SINE)

func onUpdatePoints(action: UpdatePointsAction) -> void:
	var sfx: AudioStream
	if action.isCollab(): sfx = gain_collab_point_sfx
	elif action.isPlayers() and !action.isCollab(): sfx = gain_point_sfx
	else: sfx = lose_point_sfx
	Audio.onPlaySFX(sfx, true)
