class_name AdminDatastore extends Resource

@export var autoload: bool
@export var dev_mode: bool

func isDevMode() -> bool: return dev_mode
func isAutoload() -> bool: return autoload
static func getDefaultPath() -> String: return "res://resources/test/admin_datastore.tres"
