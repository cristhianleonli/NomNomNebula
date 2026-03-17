class_name Minimap
extends Panel

const ARROW_RIGHT: Resource = preload("uid://b53onynrxfexa")

@onready var map: Panel = $Map

var existing_galaxies: Array = []
var galaxy_markers: Dictionary = {}
var markers_container: Dictionary = {}
var world_scale: float = 0.05

func _process(_delta: float) -> void:
	if Globals.player:
		var player_map_pos: Vector2 = _world_to_minimap(Globals.player.position)
		var center = self.size / 2
		map.position = center - player_map_pos - (map.size / 2)

func set_galaxies(galaxies: Array) -> void:
	_on_galaxies_updated({"galaxies": galaxies})

func _world_to_minimap(pos: Vector2) -> Vector2:
	return pos * world_scale

func _on_galaxies_updated(data: Dictionary) -> void:
	var galaxies: Array = data["galaxies"]
	existing_galaxies = galaxies

	for galaxy in galaxies:
		if not galaxy_markers.has(galaxy):
			var marker = Sprite2D.new()
			marker.texture = ARROW_RIGHT

			#markers_container.add_child(marker)
			galaxy_markers[galaxy] = marker
