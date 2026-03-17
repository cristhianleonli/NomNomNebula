class_name StabilizationComponent
extends Node

@export var max_time: float = 60.0
@export var warning_time: float = 10.0
@export var drain_rate: float = 1.0

var current_time: float
var warning_triggered: bool = false

func _ready() -> void:
	current_time = max_time
	EventManager.on_stabilization_changed.emit(_get_data())

func _process(delta: float) -> void:
	if current_time <= 0:
		return
	
	current_time -= delta * drain_rate
	current_time = max(current_time, 0)
	
	EventManager.on_stabilization_changed.emit(_get_data())
	
	if current_time <= warning_time and not warning_triggered:
		warning_triggered = true
		EventManager.on_stabilization_warning.emit()
	
	if current_time <= 0:
		_trigger_death()

func add_time(amount: float) -> void:
	current_time += amount
	current_time = min(current_time, max_time)
	
	if current_time > warning_time:
		warning_triggered = false
		EventManager.on_stabilization_warning_end.emit()
	
	EventManager.on_stabilization_changed.emit(_get_data())

func _get_progress() -> float:
	return current_time / max_time

func _trigger_death() -> void:
	EventManager.on_player_destabilized.emit()

func _get_data() -> Dictionary:
	return {
		"progress": _get_progress(),
		"current_time": current_time,
		"max_time": max_time
	}
