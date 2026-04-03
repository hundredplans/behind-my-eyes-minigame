class_name Character extends ActionManager
signal update_points

var points: int # 0 = collab, 50 = win
var deck_cards: Array[DeckCard]
var hand_cards: Array[Card]
var locked_cards: Array[LockedCard]
var status_effects: Array[StatusEffect]
var players: bool

func setInfo(_deck_cards: Array, _players: bool) -> void:
	deck_cards.assign(_deck_cards)
	deck_cards.shuffle()
	players = _players
	@warning_ignore("integer_division")
	onUpdatePoints((Data.POINTS_TO_WIN + Data.POINTS_TO_COLLABORATE) / 2)
	onConnectToActions()
	
func onAddDeckCard(deck_card: DeckCard) -> void:
	var index: int = randi_range(0, abs(deck_cards.size() - 1))
	deck_cards.insert(index, deck_card)
	
func onProcessAction(action: Action) -> void:
	if action.isPost():
		if action is CreateHandCardAction and action.getCard().isPlayers() == players:
			onCreateHandCard(action)
		elif action is PlayCardAction and action.getCard().isPlayers() == players:
			onPlayCard(action)
		elif action is CreateStatusEffectAction and action.getCharacter() == self:
			onCreateStatusEffect(action)
		elif action is RemoveStatusEffectAction and action.getCharacter() == self:
			onRemoveStatusEffect(action)
		elif action is StartTurnAction and action.isPlayers() == players:
			onStartTurn()
			
func isWin() -> bool: return points >= Data.POINTS_TO_COLLABORATE + Data.POINTS_TO_WIN
func isCollab() -> bool: return points <= 0
			
func onCreateHandCard(action: CreateHandCardAction) -> void:
	hand_cards.append(action.getCard())
	
func onPlayCard(action: PlayCardAction) -> void:
	hand_cards.erase(action.getCard())
	
func onUpdatePoints(delta: int) -> void:
	points += delta
	update_points.emit()
	
func isPlayers() -> bool: return players
func onCreateStatusEffect(action: CreateStatusEffectAction) -> void:
	status_effects.append(action.getStatusEffect())
	
func onRemoveStatusEffect(action: RemoveStatusEffectAction) -> void:
	var status_effect_info: StatusEffectInfo = action.getInfo()
	var status_effect: StatusEffect = getStatusEffect(status_effect_info)
	if status_effect == null: return
	status_effects.erase(status_effect)
	
func getStatusEffect(status_effect_info: StatusEffectInfo) -> StatusEffect:
	for status_effect: StatusEffect in status_effects:
		if status_effect.getInfo() == status_effect_info: return status_effect
	return null
	
func getStatusEffects() -> Array[StatusEffect]: return status_effects
func hasStatusEffect(info: StatusEffectInfo) -> bool:
	return status_effects.any(func(x: StatusEffect): return x.getInfo() == info)
	
func onCreateLockedCard(locked_card: LockedCard) -> void:
	locked_cards.append(locked_card)
	
func onStartTurn() -> void:
	onDeincrementLockedCards()
	
func onDeincrementLockedCards() -> void:
	var unlocked_cards: Array = [] # [LockedCard]
	for locked_card: LockedCard in locked_cards.duplicate():
		locked_card.onDeincrementTurns()
		if locked_card.isUnlocked():
			unlocked_cards.append(locked_card)
			
	if unlocked_cards.is_empty(): return
	var actions: Array = unlocked_cards.map(func(x: LockedCard): return RemoveLockedCardAction.new(x, isPlayers()))
	onPush(actions)
	
func hasLockedCard(locked_card: LockedCard) -> bool: return locked_cards.any(func(x: LockedCard): return x == locked_card)
func onRemoveLockedCard(locked_card: LockedCard) -> void:
	locked_cards.erase(locked_card)
	
func getName() -> String: return ""
func getPoints() -> int: return points
func getDeckCards() -> Array[DeckCard]: return deck_cards
func getHandCards() -> Array[Card]: return hand_cards
func getHandSize() -> int: return hand_cards.size()
func getDeckSize() -> int: return deck_cards.size()
