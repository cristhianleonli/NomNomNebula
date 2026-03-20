class_name Cloud
extends Node2D

signal on_done

@onready var sprite: Sprite2D = $Sprite2D

var bounds: float
var direction: Vector2
var speed: float = 10.0
var fading_out: bool = false

func setup(spawn_pos: Vector2, new_bounds: float):
	fading_out = false
	modulate.a = 0.0
	bounds = new_bounds
	
	sprite.frame = randi() % sprite.vframes
	var new_scale: float = randf_range(1, 1.5)
	sprite.scale = Vector2(new_scale, new_scale)
	
	direction = Vector2(
		randf_range(-1, 1),
		randf_range(-0.3, 0.3)
	).normalized()
	
	global_position = spawn_pos
	
	# Fade in
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.8)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _process(delta: float):
	global_position += direction * speed * delta
	
	var out_of_bounds: bool = (
		global_position.x > bounds or
		global_position.x < -bounds or
		global_position.y > bounds or
		global_position.y < -bounds
	)
	
	if out_of_bounds and not fading_out:
		_fade_out()

func _fade_out() -> void:
	fading_out = true
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.8)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_callback(_deactivate)

func _deactivate() -> void:
	set_process(false)
	on_done.emit()
