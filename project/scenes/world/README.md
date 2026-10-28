# Overworld systems

One **scene per location** (MC_Room, hallway, park...). `WorldManager` swaps them and puts the player on a `SpawnPoint`.

## Grid
- Tiles are 16px. Characters are 32x32 sprites; a node's position is their **feet**, on a 16px grid corner.
- The player's body covers the 2x1 tiles under its feet. Anything on physics layer 1 `world` blocks it: tile collisions, NPCs.

## Making a new location
1. New scene, root `Node2D` with `scenes/world/location.gd`. Set `location_name` and set `bounds` to the main TileMapLayer (the camera stays inside it, and small rooms get centered).
2. TileMapLayer using `resources/world/room_tileset.tres`. Give wall/furniture tiles a collision polygon.
3. `Entities` Node2D with **Y Sort Enabled**, holding `player/player.tscn` and NPCs.
4. Add `spawn_point/spawn_point.tscn` markers. Each needs a unique `id`, and `default` is used when the scene is started directly (F6).
5. Add `door/door.tscn`:
   - `target_scene`: leave it empty to teleport within the same location.
   - `target_spawn`: the `id` of a SpawnPoint in the target scene.
   - `trigger`: `ON_TOUCH` for walk-through doorways (must be on walkable tiles), `ON_INTERACT` for a door in a wall.
   - Put the arrival SpawnPoint *next to* the door, not on it.

## NPCs
`npc/npc.tscn` has these exports: `npc_name`, `portrait`, `texture`, `dialogue`, `repeat_dialogue` (`DialogueData`, created inline in the Inspector).
Connect `talked_to(times)` for custom events. The talk count is kept in `WorldManager` flags.

## Other interactables
Add `interactions/interaction area/interaction_area.tscn` with a CollisionShape2D, set `prompt`, and connect `interacted`.
To show text from code: `await DialogueManager.say(["line 1", "line 2"], "Name")`.

## Locking the player
Use `WorldManager.lockPlayer()` / `unlockPlayer()` (locks stack). Dialogue and transitions already do this.

## Outdoor areas (see `locations/town/town.tscn`)
- No tilemap: the ground is one repeating `Grass` Sprite2D. Set the Location's `bounds_rect` to the map size so the camera knows the edges.
- `props/` has houses and a tree. Each prop's origin is where it touches the ground: put them under the Y-sorted `Entities` node, on the 16px grid.
- `house_front.tscn` leaves a 32px gap in its collision under the red door, so an `ON_TOUCH` Door with `show_placeholder = false`, placed at the house's origin, works as a walk-in door.
- An invisible `Edges` StaticBody2D keeps the player inside the map; the trees along the edges are just decoration in front of it.
