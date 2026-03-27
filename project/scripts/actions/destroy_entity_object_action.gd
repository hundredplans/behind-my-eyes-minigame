class_name DestroyEntityObjectAction extends Action

var entity_object: EntityObject
func _init(_entity_object: EntityObject) -> void:
	entity_object = _entity_object
	
func onPreAction() -> void: if entity_object == null: onFailAction()
func onPostAction() -> void:
	entity_object.onDestroy()
	
func getLogInfo() -> Array: return ["Entity Object: %s" % entity_object.getName()]
