extends Node

## Player Data ##
var current_save: SaveGame = null
var current_score: int
var player: Player

## Random numbers ##
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _init() -> void:
	rng.randomize()
