extends Screen

@onready var Player: CharacterBody2D = $WorldRoot/Player
@onready var SpawnPoints: Node2D = $WorldRoot/SpawnPoints


func _ready() -> void:
	print("House loaded")

	Player.door_interacted.connect(on_door_interacted)

	if OverWorldData.target_spawn_id != "":
		move_player_to_spawn(OverWorldData.target_spawn_id)
		OverWorldData.target_spawn_id = ""


func on_door_interacted(door_data: Dictionary) -> void:
	var target_screen: Screen.Type = door_data["target_screen"]
	var target_spawn_id: String = door_data["target_spawn_id"]

	print("House door used, changing screen to: ", target_screen)
	print("Target spawn id: ", target_spawn_id)

	OverWorldData.target_spawn_id = target_spawn_id
	load_screen.emit(target_screen)


func move_player_to_spawn(spawn_id: String) -> void:
	var spawn_point := SpawnPoints.get_node_or_null(spawn_id)

	if spawn_point == null:
		print("House spawn point not found: ", spawn_id)
		return

	Player.set_saved_position(spawn_point.global_position)
