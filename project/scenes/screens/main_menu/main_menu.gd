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
@onready var DeckButton: DefaultButton =%DeckButton
@export var DeckBuilder: PackedScene
@export var deck_display_duration: float = 0.8
@export var pageflip_sfx: AudioStream

@export var scritching_sfx: AudioStream
@export var eyes_opening_sfx: AudioStream

var Deck: Node2D

var scritching: bool
var inSettings: bool=false
var inDeck: bool=false
var resolutionScale: int=3

func _ready() -> void:
	Actions.onRemoveChildren()
	Actions.onClearActionChain()
	Sprite.animation="OpenSettings"
	scritching = true
	_on_SFX_value_changed(Settings.getSettingsData().getSFXVolume())
	_on_Music_value_changed(Settings.getSettingsData().getMusicVolume())
	_on_Master_value_changed(Settings.getSettingsData().getMasterVolume())
	onUpdateWindowMode(Settings.getSettingsData().getWindowMode())
	scritching = false
	
func leaveDeck() -> void:
	var tween = create_tween()
	inDeck=false 
	tween.set_ease(Tween.EASE_IN_OUT)

	var delay: float = deck_display_duration / 2.0
	tween.tween_property(self, "position", Vector2(0,400), delay)
	await tween.finished

# This runs AFTER the tween completes
	Deck.free()
	Sprite.visible=true
	var tween2 = create_tween()
	tween2.tween_property(self, "position", Vector2(0,0), delay)
	

	DeckButton.setDisabled(false)
	Play.visible=true
	SettingsButton.visible=true
	Exit.visible=true
	Back.visible=false
	LowerRes.visible=false
	HigherRes.visible=false
	
	
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Escape") and inSettings :
		onBackPressed()
	if Input.is_action_just_pressed("Escape") and inDeck and Deck.DeckCards.size()==10:
		leaveDeck()
	
func onUpdateWindowMode(window_mode: DisplayServer.WindowMode) -> void:
	Settings.onUpdateWindowMode(window_mode)
	
func onPlayPressed() -> void:
	Blink.visible = true
	Blink.play("CloseEyes");
	Audio.onPlaySFX(eyes_opening_sfx)

func onSettingsPressed() -> void:
	Sprite.play("OpenSettings")
	Audio.onPlaySFX(pageflip_sfx)
	DeckButton.setDisabled(true)
	inSettings=true
	Play.visible=false
	SettingsButton.visible=false
	Exit.visible=false
	Back.visible=true
	LowerRes.visible=true
	HigherRes.visible=true
	
	
func onDeckPressed() -> void:
	inDeck=true
	Deck = DeckBuilder.instantiate()
	var tween = create_tween()
	
	var delay: float = deck_display_duration / 2.0
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(self, "position", Vector2(0,400), delay)
	await tween.finished

# This runs AFTER the tween completes
	Sprite.visible=false
	self.add_child(Deck)
	var tween2 = create_tween()
	tween2.tween_property(self, "position", Vector2(0,0), delay)
	
	

	DeckButton.setDisabled(true)
	Play.visible=false
	SettingsButton.visible=false
	Exit.visible=false
	Back.visible=true
	LowerRes.visible=true
	HigherRes.visible=true
	
func onBackPressed() -> void:
	inSettings=false
	Audio.onPlaySFX(pageflip_sfx)
	Settings.onSaveSettingsData()
	Sprite.play("CloseSettings")
	DeckButton.setDisabled(false)
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
	var width= value*87/100
	Settings.getSettingsData().setSFXVolume(int(value))
	Settings.onUpdateSettings()
	SFX.region_rect =Rect2(3,0,width,22)
	onPlayScritching()
	
func _on_Music_value_changed(value: float) -> void:
	var width= value*87/100
	Settings.getSettingsData().setMusicVolume(int(value))
	Settings.onUpdateSettings()
	Music.region_rect = Rect2(3,0,width,22)
	onPlayScritching()
	
func _on_Master_value_changed(value: float) -> void:
	var width= value*87/100
	Settings.getSettingsData().setMasterVolume(int(value))
	Settings.onUpdateSettings()
	Master.region_rect = Rect2(3,0,width,22)
	onPlayScritching()

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

func onPlayScritching() -> void:
	if scritching: return
	scritching = true
	await Audio.onPlaySFX(scritching_sfx).finished
	scritching = false
	
