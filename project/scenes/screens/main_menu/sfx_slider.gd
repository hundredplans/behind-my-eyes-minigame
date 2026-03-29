extends HSlider

@onready var Sprite: Sprite2D = %SFXVolume

@export
var bus_name: String = "SFX"
var bus_index: int 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(value)
	)
	var width= value*87/100
	Sprite.region_rect = Rect2(3,0,width,22)
