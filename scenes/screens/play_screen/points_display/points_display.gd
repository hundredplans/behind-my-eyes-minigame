extends Node2D

@onready var EnemyPath: Path2D = %EnemyPath
@onready var PlayerPath: Path2D = %PlayerPath

@onready var PlayerSprite: Sprite2D = %PlayerSprite
@onready var EnemySprite: Sprite2D = %EnemySprite

@export var y_same_points_offset: float = 10.0
func setInfo() -> void:
	onUpdatePoints(false)
	onUpdatePoints(true)

func onUpdatePoints(players: bool) -> void:
	var character: Character = Board.getCharacter(players)
	var other_character: Character = Board.getOtherCharacter(players)
	var points: int = character.getPoints()
	var path_position: Vector2 = getPathPosition(points, players)
	var sprite: Sprite2D = getCharacterSprite(players)
	sprite.position = path_position

	if points == other_character.getPoints():
		getCharacterSprite(false).offset.y = y_same_points_offset
		getCharacterSprite(true).offset.y = -y_same_points_offset
	else:
		sprite.offset.y = 0
		getCharacterSprite(!players).offset.y = 0
	
func getPathPosition(points: int, players: bool) -> Vector2:
	var p: float = float(Data.POINTS_TO_WIN + Data.POINTS_TO_COLLABORATE / float(points))
	var curve: Curve2D = getPath(players).curve
	var length: float = curve.get_baked_length()
	var distance: float = length * p
	return curve.sample_baked(distance)
	
func getPath(players: bool) -> Path2D:
	return PlayerPath if players else EnemyPath

func getCharacterSprite(players: bool) -> Sprite2D:
	return PlayerSprite if players else EnemySprite
