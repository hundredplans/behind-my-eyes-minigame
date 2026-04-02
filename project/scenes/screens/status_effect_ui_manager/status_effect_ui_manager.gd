extends Node2D

@onready var StatusEffectsNode: Node2D = %StatusEffectsNode
@export var StatusEffectPath: Path2D # Make this a child when instantiating this scenes
@export var StatusEffectUIPacked: PackedScene
@export var status_effect_ui_offset: float = 60.0
@export var players: bool
func _ready() -> void:
	assert(StatusEffectPath != null, "Create a child node and set the export")
	assert(StatusEffectPath.curve != null, "No curve provided")
	Actions.process_action.connect(onProcessAction)
	
func onProcessAction(action: Action) -> void:
	if action.isPost():
		if action is CreateStatusEffectAction and action.isPlayers() == players:
			onCreateStatusEffect(action.getStatusEffect())
		elif action is RemoveStatusEffectAction and action.isPlayers() == players:
			onRemoveStatusEffect(action.getStatusEffect())

func onCreateStatusEffect(status_effect: StatusEffect) -> void:
	var status_effect_ui: Node2D = StatusEffectUIPacked.instantiate()
	StatusEffectsNode.add_child(status_effect_ui)
	status_effect_ui.setStatusEffect(status_effect)
	
	var curve: Curve2D = StatusEffectPath.curve
	var distance: float = status_effect_ui_offset * (getUisAmount() - 1)
	var trans: Transform2D = curve.sample_baked_with_rotation(distance)
	status_effect_ui.position = trans.get_origin()
	status_effect_ui.rotation = trans.get_rotation()
	
func onRemoveStatusEffect(status_effect: StatusEffect) -> void:
	var status_effect_ui: Node2D = getStatusEffectUI(status_effect)
	if status_effect_ui == null: return
	status_effect_ui.onDeath()
	
func getStatusEffectUI(status_effect: StatusEffect) -> Node2D:
	for status_effect_ui: Node2D in getStatusEffectUis():
		if status_effect_ui.getStatusEffect() == status_effect: return status_effect_ui
	return null
	
func getUisAmount() -> int:
	return StatusEffectsNode.get_children()\
	.filter(func(x: Node2D): return !x.is_queued_for_deletion()).size()
	
func getStatusEffectUis() -> Array: return StatusEffectsNode.get_children()
func isPlayers() -> bool: return players
