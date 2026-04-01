extends Screen

@onready var Blink: AnimatedSprite2D = %Blink
@onready var Sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var Play: Button = %Button4
@onready var SettingsButton: Button = %Button2
@onready var Exit: Button = %Button3
@onready var Back: Button = %Button
@onready var SFX: Sprite2D =%SFXVolume
@onready var Music: Sprite2D =%MusicVolume
@onready var Master: Sprite2D =%GeneralVolume
@onready var ResolutionLabel: Label =%Resolution
@onready var LowerRes: Button =%lowerResolution
@onready var HigherRes: Button =%higherResolution


var settings_data: SettingsData
var inSettings: bool=false
var resolutionScale: int=3

func _ready() -> void:
	onUpdateSettings()
	Sprite.animation="OpenSettings"
	
func getSettingsData() -> SettingsData: return settings_data
func onSaveSettingsData() -> void:
	ResourceSaver.save(settings_data, SettingsData.getDefaultPath())

func onUpdateSettings() -> void:
	if !FileAccess.file_exists(SettingsData.getDefaultPath()):
		settings_data = SettingsData.new()
		ResourceSaver.save(settings_data, SettingsData.getDefaultPath())
	else: 
		settings_data = load(SettingsData.getDefaultPath())
		
	_on_SFX_value_changed(settings_data.getSFXVolume())
	_on_Music_value_changed(settings_data.getMusicVolume())
	_on_Master_value_changed(settings_data.getMasterVolume())
	

	onUpdateWindowMode(settings_data.getWindowMode())
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Escape") and inSettings:
		onBackPressed()
	
		
func onUpdateWindowMode(window_mode: DisplayServer.WindowMode) -> void:
	DisplayServer.window_set_mode(window_mode)
	if window_mode == DisplayServer.WINDOW_MODE_WINDOWED:
		var screen_rect: Rect2i = DisplayServer.screen_get_usable_rect()
		DisplayServer.window_set_size(screen_rect.size)
		DisplayServer.window_set_position(screen_rect.position)
	else: 
		DisplayServer.window_set_size(Vector2(1920, 1080))
		DisplayServer.window_set_position(Vector2.ZERO)
	
func onPlayPressed() -> void:
	Blink.visible = true
	Blink.play("CloseEyes");
	

func onSettingsPressed() -> void:
	Sprite.play("OpenSettings")
	inSettings=true
	Play.visible=false
	SettingsButton.visible=false
	Exit.visible=false
	Back.visible=true
	LowerRes.visible=true
	HigherRes.visible=true
	
	
	
func onBackPressed() -> void:
	inSettings=false
	onSaveSettingsData()
	Sprite.play("CloseSettings")
	Play.visible=true
	SettingsButton.visible=true
	Exit.visible=true
	Back.visible=false
	LowerRes.visible=false
	HigherRes.visible=false

func onExitPressed() -> void:
	get_tree().quit()

func _on_frame_changed() -> void:
	if Sprite.frame == 2 and Sprite.animation == "OpenSettings" :
		ResolutionLabel.visible=true
		ResolutionLabel.visible_characters=6
	if Sprite.frame == 3 and Sprite.animation == "OpenSettings" :
		ResolutionLabel.visible_characters=-1
		SFX.visible=true
		Music.visible=true
		Master.visible=true
	if Sprite.frame == 2 and Sprite.animation =="CloseSettings" :
		ResolutionLabel.visible_characters=6
		SFX.visible=false
		Music.visible=false
		Master.visible=false
	if Sprite.frame == 3 and Sprite.animation =="CloseSettings" :
		ResolutionLabel.visible=false
	
func _on_blink_animation_finished() -> void:
	load_screen.emit(Screen.Type.PLAY)
	
func _on_SFX_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, linear_to_db(value)
	)
	var width= value*87/100
	settings_data.setSFXVolume(value)
	
	SFX.region_rect =Rect2(3,0,width,22)
	
func _on_Music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		1,
		linear_to_db(value)
	)
	var width= value*87/100
	settings_data.setMusicVolume(value)
	Music.region_rect = Rect2(3,0,width,22)
	
func _on_Master_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		0,
		linear_to_db(value)
	)
	var width= value*87/100
	settings_data.setMasterVolume(value)
	Master.region_rect = Rect2(3,0,width,22)


func _on_lower_resolution() -> void:
	if resolutionScale>1:
		resolutionScale -= 1
	var x=640*resolutionScale
	var y=360*resolutionScale
	DisplayServer.window_set_size(Vector2i(x,y))
	ResolutionLabel.text = "" + str(x) + "x" + str(y)


func _on_higher_resolution() -> void:
	if resolutionScale<5:
		resolutionScale += 1 
	var x=640*resolutionScale
	var y=360*resolutionScale
	DisplayServer.window_set_size(Vector2i(x,y))
	ResolutionLabel.text = "" + str(x) + "x" + str(y)
