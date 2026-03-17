class_name GalaxySpawner
extends Node

const GALAXY: Resource = preload("uid://ge3n0d66rcq8")
const GALAXY_1 = preload("uid://baxkohgisu4jk")
const GALAXY_2 = preload("uid://bt1bbrc3g1atx")

var galaxies: Array = []

func _ready() -> void:
	var g1 = GALAXY.instantiate()
	g1.position = Vector2(213, -167)
	g1.data = GALAXY_1
	
	var g2 = GALAXY.instantiate()
	g2.position = Vector2(-228, -172)
	g2.data = GALAXY_2
	
	add_child(g1)
	add_child(g2)
	
	galaxies = [g1, g2]

func get_visible_galaxies() -> Array:
	return galaxies

func remove_galaxy(data: GalaxyData) -> void:
	for i: int in range(galaxies.size()):
		var g: Galaxy = galaxies[i]
		if g.uid() == data.uid:
			galaxies.remove_at(i)
			break
	
	EventManager.on_galaxies_updated.emit({"galaxies": galaxies})
