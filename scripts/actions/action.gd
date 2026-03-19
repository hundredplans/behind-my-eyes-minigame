@abstract
class_name Action extends ActionManager

var action_owner: ActionManager
var failed: bool
var post: bool
var forced: bool

@abstract func onPreAction() -> void
@abstract func onPostAction() -> void
@abstract func getLogInfo() -> Array

func onFailAction() -> void: failed = true
func isPost() -> bool: return post
func setForced(_forced: bool) -> void: forced = _forced
func setActionOwner(_owner: ActionManager) -> void: action_owner = _owner
func getActionOwner() -> ActionManager: return action_owner

func isFailed() -> bool: return failed
func isOwner(type: GDScript) -> bool: return owner != null and is_instance_of(owner, type)

func getDebug() -> String:
	return get_script().get_global_name()
