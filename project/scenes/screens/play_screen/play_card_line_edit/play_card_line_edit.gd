extends LineEdit

var action_chained: bool
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Enter") and has_focus():
		onTextSubmitted()
		
func onTextSubmitted(__: String = "") -> void:
	release_focus()
	
func isActionChained() -> bool: return action_chained

func onTextValid() -> void:
	text = ""
	
func onTextInvalid() -> void:
	text = ""
