extends Node

var admin_datastore: AdminDatastore
func _ready() -> void:
	admin_datastore = load(AdminDatastore.getDefaultPath())

func isDevMode() -> bool: return admin_datastore.isDevMode()
func isAutoload() -> bool: return admin_datastore.isAutoload()

func getAdminDatastore() -> AdminDatastore:
	return admin_datastore
