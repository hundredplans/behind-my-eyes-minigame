extends Node

@onready var ActionSender: ActionManager = %ActionSender

func _ready() -> void:
	Actions.process_action.connect(onProcessAction)

func onProcessAction(action: Action) -> void:
	if action.isPost():
		if action is StartGameAction:
			onStartGame()
		elif action is StartTurnAction and !action.isPlayers():
			onStartTurn()
		
func onStartGame() -> void:
	var actions: Array = [DrawCardAction.new(Data.MIN_HAND_SIZE, false)]
	onPush(actions)
	
func onStartTurn() -> void:
	var hand_cards: Array[Card] = Board.getEnemy().getHandCards()
	var actions: Array = []
	if !hand_cards.is_empty():
		var hand_card: Card = hand_cards.pick_random()
		hand_cards.erase(hand_card)
		actions.append([PlayCardAction.new(hand_card)])

	onPush(actions)
	onAppend([StartTurnAction.new(true)])
	
func onPush(actions: Array) -> void: ActionSender.onPush(actions)
func onAppend(actions: Array) -> void: ActionSender.onAppend(actions)
