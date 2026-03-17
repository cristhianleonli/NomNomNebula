class_name GalaxySpawner
extends Node

@onready var galaxy: Galaxy = $Galaxy
@onready var galaxy_2: Galaxy = $Galaxy2
@onready var galaxy_3: Galaxy = $Galaxy3
@onready var galaxy_4: Galaxy = $Galaxy4
@onready var galaxy_5: Galaxy = $Galaxy5

func _ready() -> void:
	pass

func get_visible_galaxies() -> Array:
	return [
		galaxy,
		galaxy_2,
		galaxy_3,
		galaxy_4,
		galaxy_5
	]
