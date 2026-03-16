class_name Galaxy
extends Node2D

@export var data: GalaxyData
@export var scaling_speed: float = 1

@onready var animation: AnimatedSprite2D = get_node("Animation")
@onready var size: float = data.size
@onready var timer_label: Label = $TimerLabel
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var interaction_collision_shape: CollisionShape2D = $InteractionArea/CollisionShape2D

var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	# duplicate shape to make size unique per galaxy
	var shape: CircleShape2D = interaction_collision_shape.shape.duplicate()
	shape.radius = data.interaction_radius
	interaction_collision_shape.shape = shape
	
	animation.play("main")

func _process(delta: float) -> void:
	size = lerp(size, 2.0, scaling_speed * delta)
	scale = Vector2(size, size)
	position += velocity * delta

func apply_force(force: Vector2) ->void:
	velocity += force

func _on_center_area_entered(_area: Area2D) -> void:
	Globals.player.velocity = Vector2.ZERO
	Globals.player.apply_force((Globals.player.global_position - global_position).normalized() * 500)

func _on_interaction_area_mouse_entered() -> void:
	EventManager.on_tooltip_show.emit(data)

func _on_interaction_area_mouse_exited() -> void:
	EventManager.on_tooltip_hide.emit()
