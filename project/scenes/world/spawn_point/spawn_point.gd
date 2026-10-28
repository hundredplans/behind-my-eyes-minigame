@tool
class_name SpawnPoint extends Marker2D
## Where the player appears when entering a location through a Door.
## A Door's target_spawn must match this id. Place it on the 16px grid
## (the position is the player's feet).

const GROUP: StringName = &"spawn_point"
enum Facing {KEEP, UP, DOWN, LEFT, RIGHT}

@export var id: StringName = &"default"
## Direction the player looks after arriving. KEEP = same as before the door.
@export var facing: Facing = Facing.KEEP

func _ready() -> void:
	add_to_group(GROUP)

func getFacing() -> Vector2i:
	match facing:
		Facing.UP: return Vector2i.UP
		Facing.DOWN: return Vector2i.DOWN
		Facing.LEFT: return Vector2i.LEFT
		Facing.RIGHT: return Vector2i.RIGHT
	return Vector2i.ZERO
