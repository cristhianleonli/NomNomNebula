class_name GalaxySpawner
extends Node

@onready var galaxy: Galaxy = $Galaxy

func _ready() -> void:
	pass

func get_visible_galaxies() -> Array:
	return [
		galaxy
	]
