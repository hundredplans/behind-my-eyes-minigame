extends Node

@export var MainMenuPacked: PackedScene
@export var PlayScreenPacked: PackedScene
@export var LossScreenPacked: PackedScene
@export var WinScreenPacked: PackedScene
@export var CollabScreenPacked: PackedScene
@export var DeckScreenPacked: PackedScene

var active_screen: Screen
func getScreenPacked(type: Screen.Type) -> PackedScene:
	match type:
		Screen.Type.MAIN_MENU: return MainMenuPacked
		Screen.Type.PLAY: return PlayScreenPacked
		Screen.Type.LOSS: return LossScreenPacked
		Screen.Type.WIN: return WinScreenPacked
		Screen.Type.COLLAB: return CollabScreenPacked
		Screen.Type.DECK: return DeckScreenPacked
	return null
	
func _ready() -> void:
	if !Admin.isAutoload(): onLoadScreen(Screen.Type.MAIN_MENU)
	else: onLoadScreen(Screen.Type.PLAY)
	
	onUpdateSettings()
	
func onLoadScreen(type: Screen.Type) -> void:
	if active_screen != null: active_screen.queue_free()
	var screen: Screen = getScreenPacked(type).instantiate()
	active_screen = screen
	add_child(screen)
	screen.load_screen.connect(onLoadScreen)
	
	match type:
		Screen.Type.PLAY: Audio.setPlace(Audio.Places.COMBAT)
		Screen.Type.LOSS: Audio.setPlace(Audio.Places.LOSS)
		_: Audio.setPlace(Audio.Places.MAIN_MENU)
	
func onUpdateSettings() -> void:
	if !FileAccess.file_exists(SettingsData.getDefaultPath()):
		Settings.settings_data = SettingsData.new()
		Settings.onSaveSettingsData()
	else: 
		Settings.settings_data = load(SettingsData.getDefaultPath())
	Settings.onUpdateSettings()
