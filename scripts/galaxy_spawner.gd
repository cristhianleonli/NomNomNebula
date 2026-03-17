class_name GalaxySpawner
extends Node

const GALAXY: Resource = preload("uid://ge3n0d66rcq8")

const galaxies_variants_data = [preload("uid://baxkohgisu4jk"),
						preload("uid://bt1bbrc3g1atx"),
						preload("uid://g38kwgaypusv"),
						preload("uid://53lwckvnjlyy"),
						preload("uid://d3pqhf4o3i6n4")]

var galaxies: Array = []

func _ready() -> void:
	for i in range(1):
		var galaxy : Galaxy = GALAXY.instantiate()
		galaxy.position = Vector2(200 + 300*i, -160)
		galaxy.data = galaxies_variants_data[i]
		add_child(galaxy)
		galaxies.append(galaxy)
	
func get_visible_galaxies() -> Array:
	return galaxies

func remove_galaxy(data: GalaxyData) -> void:
	for i: int in range(galaxies.size()):
		var g: Galaxy = galaxies[i]
		if g.uid() == data.uid:
			galaxies.remove_at(i)
			break
	
	EventManager.on_galaxies_updated.emit({"galaxies": galaxies})
