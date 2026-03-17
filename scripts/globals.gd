extends Node

## Player Data ##
var current_save: SaveGame = null
var current_score: int
var player: Player
var game_camera: MainCamera

## Random numbers ##
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _init() -> void:
	rng.randomize()
