class_name ResourceInfo extends Resource

@export var name: String
@export var id: int
@export_multiline var description: String

func getName() -> String: return name
func getId() -> int: return id
func getDescription() -> String: return description

func setName(_name: String) -> void: name = _name
func setId(_id: int) -> void: id = _id
func setDescription(_description: String) -> void: description = _description

func onSave() -> void:
	ResourceSaver.save(self, getPath())
	
func getPath() -> String: return "%s%s.tres" % [getDefaultPath(), name.to_lower().replace(" ", "_").replace("\"", "")]
	
static func getDefaultPath() -> String:
	push_error("Lacking implementation")
	return ""
