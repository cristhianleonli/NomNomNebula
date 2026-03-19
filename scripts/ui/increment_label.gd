class_name IncrementLabel
extends Label

var float_distance: float = 15.0
var duration: float = 0.35

func _ready():
	pass

func animate() -> void:
	modulate.a = 0.0
	
	var start_pos = position
	var end_pos = start_pos + Vector2(0, -float_distance)

	var tween = create_tween()
	tween.set_parallel(true)

	tween.tween_property(self, "modulate:a", 1.0, duration * 0.2)
	tween.tween_property(self, "position", end_pos, duration)
	tween.tween_property(self, "modulate:a", 0.0, duration).set_delay(duration * 0.2)
	tween.finished.connect(queue_free)
