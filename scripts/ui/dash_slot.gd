class_name DashSlot
extends Node

const DASH_SLOT_ATLAS: AtlasTexture = preload("uid://bujqt3uqx8g42")

@onready var texture_rect: TextureRect = $TextureRect
@onready var animation_component: AnimationComponent = $AnimationComponent

var frame_size: Vector2 = Vector2(24, 24)
var hframes: int = 22
var current_frame: int = 0
var target_frame: int = 0
var atlas: AtlasTexture
var r_tween: Tween

func _ready() -> void:
	texture_rect.texture = DASH_SLOT_ATLAS.duplicate()
	atlas = texture_rect.texture as AtlasTexture
	_set_frame(0)

func make_full() -> void:
	current_frame = 0
	target_frame = 0
	_set_frame(0)

func make_empty() -> void:
	current_frame = hframes - 1
	target_frame = hframes - 1
	_set_frame(hframes - 1)

func play_consume() -> void:
	if r_tween:
		r_tween.kill()

	r_tween = get_tree().create_tween()
	r_tween.tween_method(_update_from_float, current_frame, hframes - 1, 0.5)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)

func _set_frame(frame: int) -> void:
	frame = clamp(frame, 0, hframes - 1)
	atlas.region = Rect2(
		frame * frame_size.x,
		0,
		frame_size.x,
		frame_size.y
	)

func _update_from_float(value: float) -> void:
	current_frame = int(value)
	_set_frame(int(value))

func show_wobble() -> void:
	animation_component.subtle_wobble()

func set_fill_progress(value: float) -> void:
	if r_tween:
		r_tween.kill()
	
	var frame: float = (1.0 - value) * (hframes - 1)
	current_frame = int(frame)
	_set_frame(int(frame))
