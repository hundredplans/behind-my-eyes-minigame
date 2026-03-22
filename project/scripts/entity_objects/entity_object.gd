@abstract
class_name EntityObject extends ActionManager

func _init(_info: ResourceInfo) -> void:
	assert(_info != null, "Initialised with null info")
	info = _info

var info: ResourceInfo
func getName() -> String: return info.getName()
@abstract func getInfo() -> ResourceInfo
