extends Screen

@export var PauseMenuPacked: PackedScene
@export var deck: Array[DeckCard]
var PauseMenu: Control
func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Escape") and !isPauseMenu():
		onCreatePauseMenu()

func onCreatePauseMenu() -> void:
	PauseMenu = PauseMenuPacked.instantiate()
	add_child(PauseMenu)
	PauseMenu.setInfo()
	
func isPauseMenu() -> bool: return PauseMenu != null
