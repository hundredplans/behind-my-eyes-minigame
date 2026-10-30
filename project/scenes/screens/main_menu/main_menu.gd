extends Screen

@onready var viewport = $SubViewport
@onready var Background_Sprite:  AnimatedSprite2D  = $Background
@onready var Background_Shader:  AnimatedSprite2D  = $SubViewport/BackgroundShader
@onready var Foreground:  AnimatedSprite2D  = $Foreground
@onready var Leaves:  AnimatedSprite2D  = $Leaves
@onready var Petals:  AnimatedSprite2D  =  $Petals
@onready var Otis:  AnimatedSprite2D  = $Otis
@onready var timer: Timer = $SubViewport/BackgroundShader/Timer
@onready var Grass_Shader:  AnimatedSprite2D  = $SubViewport2/GrassShader
@onready var foreground_Viewport = $SubViewport2
@onready var Ground_Shader:  AnimatedSprite2D  = $SubViewport2/GroundShader
@onready var ContinueLabel: Label = $Continue/ContinueLabel

@onready var NewGameLabel: Label = $NewGameButton/NewGameLabel
@onready var SettingsLabel: Label = $SettingsButton/SettingsLabel
@onready var ExitLabel: Label = $ExitButton/ExitLabel

@export var SettingsMenu: PackedScene 

var labels: Array[Label]
var PlayPressed: bool = false
func _ready():
	var mat = Background_Sprite.material as ShaderMaterial
	mat.set_shader_parameter(
		"mask_texture",
		viewport.get_texture()
	)
	var mat2 = Foreground.material as ShaderMaterial
	mat2.set_shader_parameter(
		"mask_texture",
		foreground_Viewport.get_texture()
	)
	var mat3 = Leaves.material as ShaderMaterial
	mat3.set_shader_parameter(
		"mask_texture",
		foreground_Viewport.get_texture()
	)
	labels.append(ContinueLabel)
	labels.append(NewGameLabel)
	labels.append(SettingsLabel)
	labels.append(ExitLabel)
	
	#start Idle animations
	#Grass_Shader.play("default")
	Background_Sprite.play("default")
	#Ground_Shader.play("default")
	Foreground.play("default")
	Leaves.play("default")
	Petals.play("default")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	Grass_Shader.frame = Foreground.frame + 2 *Ground_Shader.frame + 2* int(PlayPressed)
	


#autoplay idle animationg every x seconds
func _on_timer_timeout() -> void:
	Background_Shader.play("Idle")

func _on_continue_pressed() -> void:
	if(PlayPressed):
		return
	PlayPressed=true
	timer.paused=true
	Otis.play("Play")
	Background_Shader.play("Play")
	Ground_Shader.play("Play")


func _on_new_game_button_pressed() -> void:
	if(PlayPressed):
		return
#	Need save system for this
	pass # Replace with function body.


func _on_settings_button_pressed() -> void:
	if(PlayPressed):
		return
	var Settings_Menu = SettingsMenu.instantiate()
	self.add_child(Settings_Menu)
	print(SettingsMenu)


func _on_exit_button_pressed() -> void:
	if(PlayPressed):
		return
	get_tree().quit()


func look_at_buttons() -> void:
	if(PlayPressed):
		return
	timer.paused=true
	Otis.play("Buttons")
	Background_Shader.play("LookAtButton")
	Grass_Shader.play("default")
	Grass_Shader.pause()
	Ground_Shader.play("Button")
	
func return_to_idle() -> void:
	if(PlayPressed):
		return  
	timer.paused=false
	Otis.play_backwards("Buttons")
	Background_Shader.play_backwards("LookAtButton")
	Grass_Shader.play("default")
	Grass_Shader.pause()
	Ground_Shader.play_backwards("Button")

	timer.paused=true
	
func _on_button_mouse_entered(labelnum: int) -> void:
	labels[labelnum].add_theme_color_override("font_color",Color.DARK_GRAY)
	look_at_buttons()

func _on_button_mouse_exited() -> void:
	for label in labels:
		label.remove_theme_color_override("font_color")
	return_to_idle()


func _on_ground_shader_animation_finished() -> void:
	if(Ground_Shader.animation=="Play"):
		load_screen.emit(Screen.Type.WORLD)
	pass # Replace with function body.
