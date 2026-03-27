extends Screen

func onMainMenuPressed() -> void:
	load_screen.emit(Screen.Type.MAIN_MENU)
