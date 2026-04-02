extends LineEdit

@export var uneditable_color := Color.GRAY

const INVALID_DELAY: float = 1.0

var action_chained: bool
var invalid_cooldown: bool
var InvalidTween: Tween

func _ready() -> void: grab_focus()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Enter") and editable:
		onTextSubmitted()
		
func onTextSubmitted(__: String = "") -> void: pass
	
func _notification(what):
	if what == NOTIFICATION_FOCUS_EXIT:
		call_deferred("grab_focus")
	
func isActionChained() -> bool: return action_chained
func setActionChained(state: bool) -> void:
	action_chained = state
	onUpdateEditable()
	
func setInvalidCooldown(state: bool) -> void:
	invalid_cooldown = state
	onUpdateEditable()

func onUpdateEditable() -> void:
	editable = !(action_chained or invalid_cooldown)
	self_modulate = Color.WHITE if editable else uneditable_color

func onTextValid() -> void:
	text = ""
	
func onTextInvalid() -> void:
	setInvalidCooldown(true)
	text = ""
	
	if InvalidTween: InvalidTween.kill()
	InvalidTween = create_tween()
	
	var delay: float = INVALID_DELAY / 3.0
	InvalidTween.tween_property(self, "modulate", Color.RED, delay)
	InvalidTween.tween_interval(delay)
	InvalidTween.tween_property(self, "modulate", Color.WHITE, delay)
	
	
	await InvalidTween.finished
	setInvalidCooldown(false)
