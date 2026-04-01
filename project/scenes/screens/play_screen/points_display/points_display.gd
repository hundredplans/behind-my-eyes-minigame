extends Node2D

@onready var EnemyPathFollow: PathFollow2D = %EnemyPathFollow
@onready var PlayerPathFollow: PathFollow2D = %PlayerPathFollow
@onready var EnemyPath: Path2D = %EnemyPath
@onready var PlayerPath: Path2D = %PlayerPath

@onready var PlayerSprite: Sprite2D = %PlayerSprite
@onready var EnemySprite: Sprite2D = %EnemySprite

@export var StatUpdateVFXPacked: PackedScene
@export var travel_speed: float = 0.5
@export var x_same_points_offset: float = 10.0

var PlayerPathTween: Tween
var EnemyPathTween: Tween

var previous_player_points: int
var previous_enemy_points: int

func setInfo() -> void:
	Board.getPlayer().update_points.connect(onUpdatePoints.bind(true))
	Board.getEnemy().update_points.connect(onUpdatePoints.bind(false))
	onUpdatePoints(false, true)
	onUpdatePoints(true, true)

func onUpdatePoints(players: bool, instant: bool = false) -> void:
	var character: Character = Board.getCharacter(players)
	var other_character: Character = Board.getOtherCharacter(players)
	var points: int = clamp(character.getPoints(), 0, Data.POINTS_TO_WIN + Data.POINTS_TO_COLLABORATE)
	
	var progress_ratio: float = float(float(points) / float(Data.POINTS_TO_WIN + Data.POINTS_TO_COLLABORATE))
	var path_follow: PathFollow2D = getPathFollow(players)
	var sprite: Sprite2D = getCharacterSprite(players)
	
	if !instant:
		var tween = getPathUpdateTween(players)
		tween.tween_property(path_follow, "progress_ratio", progress_ratio - path_follow.progress_ratio, travel_speed)\
		.as_relative().set_trans(Tween.TRANS_SINE)
		
		var delta: int = points - (previous_player_points if players else previous_enemy_points)
		if delta != 0:
			var stat_update_vfx: Node2D = StatUpdateVFXPacked.instantiate()
			add_child(stat_update_vfx)
			stat_update_vfx.global_position = sprite.global_position
			stat_update_vfx.setInfo(delta)
		
	else: path_follow.progress_ratio = progress_ratio

	
	if points <= Data.POINTS_TO_WIN and (points == other_character.getPoints()):
		getCharacterSprite(false).offset.x = x_same_points_offset
		getCharacterSprite(true).offset.x = -x_same_points_offset
	else:
		sprite.offset.x = 0
		getCharacterSprite(!players).offset.x = 0
		
	if players: previous_player_points = points
	else: previous_enemy_points = points
	
func getPath(players: bool) -> Path2D:
	return PlayerPath if players else EnemyPath

func getCharacterSprite(players: bool) -> Sprite2D:
	return PlayerSprite if players else EnemySprite
	
func getPathFollow(players: bool) -> PathFollow2D:
	return PlayerPathFollow if players else EnemyPathFollow

func getPathUpdateTween(players: bool) -> Tween:
	if players:
		if PlayerPathTween: PlayerPathTween.kill()
		PlayerPathTween = create_tween()
		return PlayerPathTween
	if EnemyPathTween: EnemyPathTween.kill()
	EnemyPathTween = create_tween()
	return EnemyPathTween
