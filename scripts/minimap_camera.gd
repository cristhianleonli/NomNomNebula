extends Camera2D

@export var world_scale: float = 0.1

func _process(_delta):
	if Globals.player:
		position = Globals.player.position * world_scale
