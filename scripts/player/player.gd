class_name Player
extends Node2D

@onready var dash_component: DashComponent = $DashComponent
@onready var stabilization_component: StabilizationComponent = $StabilizationComponent
@onready var player_movement: PlayerMovement = $PlayerMovement

var can_move: bool = true
var target_size: float = 0.5
var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	EventManager.on_game_state_changed.connect(_on_game_state_changed)

func _process(_delta: float) -> void:
	pass

func use_dash() -> void:
	dash_component.use_dash()
	EventManager.on_camera_shake.emit(0.7, 1.0)

func use_dash_error() -> void:
	EventManager.on_dash_error.emit()
	dash_component.dash_error()

func get_dash_count() -> int:
	return dash_component.dash_count

func can_dash() -> bool:
	return dash_component.can_dash()

func apply_force(force: Vector2) -> void:
	velocity += force

func absorb_galaxy(data: BuffDebuff) -> void:
	stabilization_component.add_time(data.stability_time)
	target_size += data.mass

func _on_game_state_changed(state: GameWorld.GameState) -> void:
	match state:
		GameWorld.GameState.ONGOING:
			can_move = true
		GameWorld.GameState.PAUSED:
			can_move = false
		GameWorld.GameState.FINISHED:
			can_move = false
