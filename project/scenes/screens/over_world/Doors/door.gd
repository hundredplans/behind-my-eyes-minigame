extends Area2D
class_name Door

@export var target_screen: Screen.Type = Screen.Type.MAIN_MENU
@export var target_spawn_id: String = ""

func interact() -> Dictionary:
	return {
		"target_screen": target_screen,
		"target_spawn_id": target_spawn_id
	}


func _draw() -> void:
	draw_rect(Rect2(Vector2(-8, -8), Vector2(16, 16)), Color.RED)
