extends Screen

@onready var BackgroundRect: ColorRect = %BackgroundRect
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

var inSettings: bool
var exiting: bool
var resolutionScale = 3

func _ready() -> void:
	Blink.play("OpenEyes")
	Sprite.animation="OpenSettings"
	_on_SFX_value_changed(Settings.getSettingsData().getSFXVolume())
	_on_Music_value_changed(Settings.getSettingsData().getMusicVolume())
	_on_Master_value_changed(Settings.getSettingsData().getMasterVolume())
	onUpdateWindowMode(Settings.getSettingsData().getWindowMode())

func onUpdateWindowMode(window_mode: DisplayServer.WindowMode) -> void:
	DisplayServer.window_set_mode(window_mode)
	if window_mode == DisplayServer.WINDOW_MODE_WINDOWED:
		var screen_rect: Rect2i = DisplayServer.screen_get_usable_rect()
		DisplayServer.window_set_size(screen_rect.size)
		DisplayServer.window_set_position(screen_rect.position)
	else:
		DisplayServer.window_set_size(Vector2(1920, 1080))
		DisplayServer.window_set_position(Vector2.ZERO)
	


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Escape") and inSettings:
		onBackPressed()
	if Input.is_action_just_pressed("Escape") and !inSettings:
		onPlayPressed()
	
func onPlayPressed() -> void:
	Blink.visible = true
	Blink.play("CloseEyes");
	
	
	

func onSettingsPressed() -> void:
	Sprite.play("OpenSettings")
	Play.visible=false
	SettingsButton.visible=false
	Exit.visible=false
	Back.visible=true
	inSettings=true
	LowerRes.visible=true
	HigherRes.visible=true
	
	
func onBackPressed() -> void:
	inSettings=false
	Settings.onSaveSettingsData()
	Sprite.play("CloseSettings")
	Play.visible=true
	SettingsButton.visible=true
	Exit.visible=true
	Back.visible=false
	LowerRes.visible=false
	HigherRes.visible=false

func onExitPressed() -> void:
	print("this should exit")
	load_screen.emit(Screen.Type.MAIN_MENU)

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
	if Blink.animation == "CloseEyes":
		Sprite.visible=false
		BackgroundRect.visible=false
		Blink.play("OpenEyes")
		exiting=true

	else:
		if exiting:
			queue_free()
		Blink.visible=false
		
	
	
func _on_SFX_value_changed(value: float) -> void:
	var width= value*87/100
	Settings.getSettingsData().setSFXVolume(int(value))
	Settings.onUpdateSettings()
	SFX.region_rect = Rect2(3,0,width,22)
	
func _on_Music_value_changed(value: float) -> void:
	var width= value*87/100
	Settings.getSettingsData().setMusicVolume(int(value))
	Settings.onUpdateSettings()
	Music.region_rect = Rect2(3,0,width,22)
	
func _on_Master_value_changed(value: float) -> void:
	var width= value*87/100
	Settings.getSettingsData().setMasterVolume(int(value))
	Settings.onUpdateSettings()
	Master.region_rect = Rect2(3,0,width,22)
	
func _on_lower_resolution() -> void:
	if resolutionScale>1:
		resolutionScale -= 1
	Settings.onUpdateResolutionScale(resolutionScale)
	var x=640*resolutionScale
	var y=360*resolutionScale
	ResolutionLabel.text = "" + str(x) + "x" + str(y)

func _on_higher_resolution() -> void:
	if resolutionScale<5:
		resolutionScale += 1
	var x=640*resolutionScale
	var y=360*resolutionScale
	Settings.onUpdateResolutionScale(resolutionScale)
	ResolutionLabel.text = "" + str(x) + "x" + str(y)
