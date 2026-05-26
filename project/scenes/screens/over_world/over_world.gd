extends Screen

@onready var Player: CharacterBody2D = $WorldRoot/Player

func _ready() -> void:
	print("OverWorld loaded")

	if OverWorldData.has_saved_position:
		Player.set_saved_position(OverWorldData.player_position)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("go_to_over_world"):
		OverWorldData.player_position = Player.global_position
		OverWorldData.has_saved_position = true
		load_screen.emit(Screen.Type.MAIN_MENU)
