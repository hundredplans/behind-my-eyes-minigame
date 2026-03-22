extends Screen

func onPlayPressed() -> void:
	load_screen.emit(Screen.Type.PLAY)

func onSettingsPressed() -> void:
	pass # Replace with function body.

func onExitPressed() -> void:
	get_tree().quit()
