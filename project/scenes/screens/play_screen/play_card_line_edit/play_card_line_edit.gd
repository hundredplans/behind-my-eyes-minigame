extends LineEdit

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Enter") and has_focus():
		onTextSubmitted()
		
func onTextSubmitted(__: String = "") -> void:
	release_focus()
	text = ""
