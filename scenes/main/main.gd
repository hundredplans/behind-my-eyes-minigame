extends Node

@export var MainMenuPacked: PackedScene
@export var PlayScreenPacked: PackedScene

var active_screen: Screen
func getScreenPacked(type: Screen.Type) -> PackedScene:
	match type:
		Screen.Type.MAIN_MENU: return MainMenuPacked
		Screen.Type.PLAY: return PlayScreenPacked
	return null
	
func _ready() -> void:
	if !Admin.isAutoload(): onLoadScreen(Screen.Type.MAIN_MENU)
	else: onLoadScreen(Screen.Type.PLAY)
	
func onLoadScreen(type: Screen.Type) -> void:
	if active_screen != null: active_screen.queue_free()
	var screen: Screen = getScreenPacked(type).instantiate()
	active_screen = screen
	add_child(screen)
	screen.load_screen.connect(onLoadScreen)
