extends Node

var settings_data: SettingsData
func _ready() -> void:
	onUpdateSettings()
	
func getSettingsData() -> SettingsData: return settings_data
func onSaveSettingsData() -> void:
	ResourceSaver.save(settings_data, SettingsData.getDefaultPath())

func onUpdateSettings() -> void:
	if !FileAccess.file_exists(SettingsData.getDefaultPath()):
		settings_data = SettingsData.new()
		ResourceSaver.save(settings_data, SettingsData.getDefaultPath())
	else: settings_data = load(SettingsData.getDefaultPath())
	
	AudioServer.set_bus_volume_db(0, settings_data.getMasterVolumeDb())
	AudioServer.set_bus_volume_db(1, settings_data.getMusicVolumeDb())
	AudioServer.set_bus_volume_db(2, settings_data.getSFXVolumeDb())
	
	onUpdateWindowMode(settings_data.getWindowMode())
	
func onUpdateWindowMode(window_mode: DisplayServer.WindowMode) -> void:
	if window_mode == settings_data.getWindowMode(): return
	settings_data.setWindowMode(window_mode)
	DisplayServer.window_set_mode(window_mode)
	if window_mode == DisplayServer.WINDOW_MODE_WINDOWED:
		var screen_rect: Rect2i = DisplayServer.screen_get_usable_rect()
		DisplayServer.window_set_size(screen_rect.size)
		DisplayServer.window_set_position(screen_rect.position)
	else:
		DisplayServer.window_set_size(Vector2(1920, 1080))
		DisplayServer.window_set_position(Vector2.ZERO)
	
func onUpdateResolutionScale(resolution_scale: int) -> void:
	settings_data.setResolutionScale(resolution_scale)
	var x=640*resolution_scale
	var y=360*resolution_scale
	DisplayServer.window_set_size(Vector2i(x,y))
