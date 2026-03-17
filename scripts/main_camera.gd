class_name MainCamera
extends Camera2D

var zoom_target : Vector2 = Vector2(1.0, 1.0)
@export var target : Node2D
@export var follow_reduction_factor : float = 1
@export var zoom_speed : float = 1

var rng = RandomNumberGenerator.new()
var shaking : bool = false
var shake_strength : float
var shake_time : float
var target_zoom: Vector2 = Vector2(1, 1)

func _ready() -> void:
	EventManager.on_camera_shake.connect(on_start_shake)

func _process(delta: float) -> void:
	if target == Globals.player:
		target_zoom = Vector2.ONE - Vector2(Globals.player.velocity.length() * 0.0015, Globals.player.velocity.length() * 0.0015)
	
	if shake_strength > 0:
		position += get_random_offset()
		shake_strength = lerpf(shake_strength, 0, 5.0*delta)
		
	position += (target.global_position - global_position)/follow_reduction_factor * delta
	zoom = lerp(zoom, target_zoom, zoom_speed*delta)

func set_target(_target) -> void:
	target = _target

func on_start_shake(strength, time) -> void:
	shake_strength = strength

func get_random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
