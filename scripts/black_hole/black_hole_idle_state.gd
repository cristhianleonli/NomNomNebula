class_name BlackHoleIdle
extends State

@export var attraction_area: Area2D

var direction: float = 0

func enter() -> void:
	attraction_area.area_entered.connect(start_attraction_state)
	
func start_attraction_state(_area: Area2D) -> void:
	change_state.emit(self, "blackholeattrach")
	
func exit() -> void:
	attraction_area.area_entered.disconnect(start_attraction_state)
