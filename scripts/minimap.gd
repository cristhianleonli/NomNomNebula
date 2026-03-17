class_name Minimap
extends Panel

const MINIMAP_MARKER: Resource = preload("uid://6yo25fpoqpne")

@onready var map: Panel = $Map

var existing_galaxies: Array = []
var galaxy_markers: Dictionary = {}
var world_scale: float = 0.1

func _process(_delta: float) -> void:
	if not Globals.player:
		return
	var player_map_pos: Vector2 = _world_to_minimap(Globals.player.position)
	var center: Vector2 = self.size / 2
	map.position = center - player_map_pos - (map.size / 2)
	
	for galaxy in existing_galaxies:
		if not galaxy_markers.has(galaxy.uid()):
			continue

		var marker: Node = galaxy_markers[galaxy.uid()]
		var map_pos: Vector2 = _world_to_minimap(galaxy.position)
		marker.position = map_pos + (map.size / 2)

func set_galaxies(galaxies: Array) -> void:
	_on_galaxies_updated({"galaxies": galaxies})

func _world_to_minimap(pos: Vector2) -> Vector2:
	return pos * world_scale

func _on_galaxies_updated(data: Dictionary) -> void:
	var galaxies: Array = data["galaxies"]
	existing_galaxies = galaxies

	for galaxy in galaxies:
		if not galaxy_markers.has(galaxy):
			var marker = TextureRect.new()
			marker.texture = MINIMAP_MARKER
			marker.scale = Vector2(0.5, 0.5)
			marker.pivot_offset_ratio = Vector2(0.5, 0.5)
			marker.position = _world_to_minimap(galaxy.position) + (map.size / 2)
			map.add_child(marker)
			
			galaxy_markers[galaxy.uid()] = marker
