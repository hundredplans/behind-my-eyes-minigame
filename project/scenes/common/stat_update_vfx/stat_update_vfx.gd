extends Node2D


@onready var ValueLabel: Label = %ValueLabel
@onready var IconSprite: Sprite2D = %IconSprite

@export var win_icon: AtlasTexture
@export var collab_icon: AtlasTexture

@export var win_color: Color
@export var collab_color: Color

@export var win_label_position: Vector2
@export var collab_label_position: Vector2

@export var duration: float = 1.25
@export var distance: float = 50.0
@export var spin: float = PI / 4.0

func setInfo(value: int) -> void:
	var win: bool = value > 0
	ValueLabel.text = "+%s" % abs(value)
	ValueLabel.modulate = win_color if win else collab_color
	ValueLabel.position = win_label_position if win else collab_label_position
	IconSprite.texture = win_icon if win else collab_icon
	modulate.a = 0.0
	
	var angle: float = randf_range(0, PI * 2)
	var direction := Vector2(cos(angle), sin(angle))
	var tween := create_tween()
	tween.tween_property(self, "position", distance * direction, duration)\
		.as_relative().set_trans(Tween.TRANS_SINE)
	
	var mtween := create_tween()
	mtween.tween_property(self, "modulate:a", 1.0, duration / 5.0)
	mtween.tween_interval((duration / 5.0) * 2.0)
	mtween.tween_property(self, "modulate:a", 0.0, (duration / 5.0) * 2.0)
	
	var rtween := create_tween()
	rtween.tween_property(self, "rotation", spin, duration)\
		.as_relative().set_trans(Tween.TRANS_SINE)

	await tween.finished
	queue_free()
