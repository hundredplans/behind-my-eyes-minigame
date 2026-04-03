class_name SettingsData extends Resource

@export_storage var master_volume: int = 100
@export_storage var music_volume: int = 100
@export_storage var sfx_volume: int = 100
@export_storage var game_speed: float = 1.0
@export_storage var resolutionScale: int=3
@export_storage var window_mode: DisplayServer.WindowMode
@export_storage var english: bool
@export_storage var DeckCards: Array[int] = [1,2,3,4,5,6,7,8,9,10]

func getMasterVolume() -> int: return master_volume
func getMusicVolume() -> int: return music_volume
func getSFXVolume() -> int: return sfx_volume
func getWindowMode() -> DisplayServer.WindowMode: return window_mode

func setMasterVolume(_master_volume: int) -> void: master_volume = _master_volume
func setMusicVolume(_music_volume: int) -> void: music_volume = _music_volume
func setSFXVolume(_sfx_volume: int) -> void: sfx_volume = _sfx_volume
func setWindowMode(_window_mode: DisplayServer.WindowMode) -> void: window_mode = _window_mode
func setGameSpeed(_game_speed: float) -> void: game_speed = _game_speed
func setEnglish(_english: bool) -> void: english = _english

func getMasterVolumeDb() -> float: return toDb(master_volume)
func getMusicVolumeDb() -> float: return toDb(music_volume)
func getSFXVolumeDb() -> float: return toDb(sfx_volume)
func getGameSpeed() -> float: return game_speed
func isEnglish() -> bool: return english

func toDb(vol: int) -> float: return (abs((float(vol) * 0.01) - 1) * -12.0) if vol > 0.5 else -60.0

static func getDefaultPath() -> String: return "user://settings_data.tres"
