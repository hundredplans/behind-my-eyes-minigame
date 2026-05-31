extends Screen

@onready var Player: CharacterBody2D = $WorldRoot/Player
@onready var SpawnPoints: Node2D = $WorldRoot/SpawnPoints


func _ready() -> void:
	print("OverWorld loaded")

	Player.door_interacted.connect(on_door_interacted)

	if OverWorldData.target_spawn_id != "":
		move_player_to_spawn(OverWorldData.target_spawn_id)
		OverWorldData.target_spawn_id = ""
	elif OverWorldData.has_saved_position:
		Player.set_saved_position(OverWorldData.player_position)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("go_to_over_world"):
		OverWorldData.target_spawn_id = ""
		save_player_position()
		load_screen.emit(Screen.Type.MAIN_MENU)


func on_door_interacted(door_data: Dictionary) -> void:
	var target_screen: Screen.Type = door_data["target_screen"]
	var target_spawn_id: String = door_data["target_spawn_id"]

	print("Door used, changing screen to: ", target_screen)
	print("Target spawn id: ", target_spawn_id)

	OverWorldData.target_spawn_id = target_spawn_id

	save_player_position()
	load_screen.emit(target_screen)


func save_player_position() -> void:
	OverWorldData.player_position = Player.global_position
	OverWorldData.has_saved_position = true


func move_player_to_spawn(spawn_id: String) -> void:
	var spawn_point := SpawnPoints.get_node_or_null(spawn_id)

	if spawn_point == null:
		print("Spawn point not found: ", spawn_id)
		return

	Player.set_saved_position(spawn_point.global_position)
