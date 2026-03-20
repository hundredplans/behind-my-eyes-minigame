extends Node

var player: Character
var enemy: Character

func setPlayer(_player: Character) -> void: player = _player
func setEnemy(_enemy: Character) -> void: enemy = _enemy

func getPlayer() -> Character: return player
func getEnemy() -> Character: return enemy

func getCharacter(players: bool) -> Character: return player if players else enemy
func getOtherCharacter(players: bool) -> Character: return getCharacter(!players)
