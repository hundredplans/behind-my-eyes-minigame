extends Screen

@onready var Sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var Play: Button = %Button4
@onready var SettingsButton: Button = %Button2
@onready var Exit: Button = %Button3
@onready var Back: Button = %Button

@onready var SFX: Sprite2D =%SFXVolume
@onready var Music: Sprite2D =%MusicVolume
@onready var Master: Sprite2D =%GeneralVolume

func onPlayPressed() -> void:
	load_screen.emit(Screen.Type.PLAY)
	

func onSettingsPressed() -> void:
	Sprite.play("OpenSettings")
	Play.visible=false
	SettingsButton.visible=false
	Exit.visible=false
	Back.visible=true
	
	
	
func onBackPressed() -> void:
	Sprite.play("CloseSettings")
	Play.visible=true
	SettingsButton.visible=true
	Exit.visible=true
	Back.visible=false

func onExitPressed() -> void:
	get_tree().quit()

func _on_frame_changed() -> void:
	if Sprite.frame == 3 and Sprite.animation == "OpenSettings" :
		SFX.visible=true
		Music.visible=true
		Master.visible=true
	if Sprite.frame == 2 and Sprite.animation =="CloseSettings" :
		SFX.visible=false
		Music.visible=false
		Master.visible=false
