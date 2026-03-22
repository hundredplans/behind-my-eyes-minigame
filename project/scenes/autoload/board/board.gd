extends Node

var player: Character
var enemy: Character
var field_cards: Array[Card]

func getPlayer() -> Character: return player
func getEnemy() -> Character: return enemy
func getFieldCards() -> Array[Card]: return field_cards

func setPlayer(_player: Character) -> void: player = _player
func setEnemy(_enemy: Character) -> void: enemy = _enemy
func setFieldCards(_field_cards: Array[Card]) -> void: field_cards = _field_cards
func onAppendFieldCard(card: Card) -> void: field_cards.append(card)
func onResetFieldCards() -> void: setFieldCards([])

func getCharacter(players: bool) -> Character: return player if players else enemy
func getOtherCharacter(players: bool) -> Character: return getCharacter(!players)
