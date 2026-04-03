class_name FilterCardsInCatalogAction extends Action
var filter: int
func _init(_filter: int) -> void:
	filter=_filter
func onPreAction() -> void:
	if filter == null: onFailAction()
	
func onPostAction() -> void:
	return
func getLogInfo() -> Array:
	return []
