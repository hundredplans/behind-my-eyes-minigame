extends Node2D

@onready var EnemyPath: Path2D = %EnemyPath
@onready var PlayerPath: Path2D = %PlayerPath

@onready var PlayerSprite: Sprite2D = %PlayerSprite
@onready var EnemySprite: Sprite2D = %EnemySprite

@export var x_same_points_offset: float = 10.0
func setInfo() -> void:
	Board.getPlayer().update_points.connect(onUpdatePoints.bind(true))
	Board.getEnemy().update_points.connect(onUpdatePoints.bind(false))
	onUpdatePoints(false)
	onUpdatePoints(true)

func onUpdatePoints(players: bool) -> void:
	var character: Character = Board.getCharacter(players)
	var other_character: Character = Board.getOtherCharacter(players)
	var points: int = character.getPoints()
	var path_position: Vector2 = getPathPosition(points, players)
	var sprite: Sprite2D = getCharacterSprite(players)
	sprite.position = path_position

	if points <= Data.POINTS_TO_WIN and (points == other_character.getPoints()):
		getCharacterSprite(false).offset.x = x_same_points_offset
		getCharacterSprite(true).offset.x = -x_same_points_offset
	else:
		sprite.offset.x = 0
		getCharacterSprite(!players).offset.x = 0
	
func getPathPosition(points: int, players: bool) -> Vector2:
	var p: float = float(float(points) / float(Data.POINTS_TO_WIN + Data.POINTS_TO_COLLABORATE))
	var curve: Curve2D = getPath(players).curve
	var length: float = curve.get_baked_length()
	var distance: float = length * p
	return curve.sample_baked(distance)
	
func getPath(players: bool) -> Path2D:
	return PlayerPath if players else EnemyPath

func getCharacterSprite(players: bool) -> Sprite2D:
	return PlayerSprite if players else EnemySprite
