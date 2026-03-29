extends Node

var infos: Dictionary # [GDScript, Dictionary[int, String (path)]]
var info_types: Array[GDScript] = [CardInfo, EnemyInfo, StatusEffectInfo]

func _ready() -> void:
	for info_type: GDScript in info_types:
		var resources: Array = getResourceArray(info_type.getDefaultPath())
		var resource_dict: Dictionary[int, String] = {}
		for resource_info: ResourceInfo in resources:
			resource_dict[resource_info.getId()] = resource_info.getPath()
		infos[info_type] = resource_dict

func getInfos(type: GDScript): return infos[type].values().map(func(x: String): return load(x))
func getInfo(type: GDScript, id: int) -> ResourceInfo: return load(infos[type][id])

func getHighestId(type: GDScript) -> int:
	var resources: Array = infos[type].keys()
	if resources.is_empty(): return 1
	return resources.max()
	
func getHighestResourceId(resource_path: String) -> int:
	var arr: Array = getResourceArray(resource_path)
	if arr.is_empty(): return 0
	return (arr.map(func(x: Resource): return x.getId())).max()
	
func getResourceArray(base_path: String) -> Array:
	return Array(DirAccess.get_files_at(base_path)).map(func(x: String): return load(base_path + x))

#func onCreateCardInfo(card_info: CardInfo) -> void:
	#infos[CardInfo][card_info.getId()] = card_info.getPath()
