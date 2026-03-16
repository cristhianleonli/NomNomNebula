class_name Player
extends Node2D

@export var dash_speed: float = 200
@export var acceleration: float = 300
@export var friction: float = 0.98

@onready var dash_component: DashComponent = $DashComponent
@onready var stabilization_component: StabilizationComponent = $StabilizationComponent

var velocity: Vector2 = Vector2.ZERO
var can_move: bool = true

func _ready() -> void:
	EventManager.on_game_state_changed.connect(_on_game_state_changed)

func _process(delta: float) -> void:
	if not can_move:
		return
	
	var input_dir: Vector2 = _get_input_direction()

	if input_dir != Vector2.ZERO:
		velocity += input_dir * acceleration * delta

	if Input.is_action_just_pressed("dash"):
		try_dash(input_dir)

	position += velocity * delta
	velocity *= friction

func _get_input_direction() -> Vector2:
	var dir: Vector2 = Vector2.ZERO

	dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	return dir.normalized()

func try_dash(input_dir: Vector2) -> void:
	if dash_component.can_dash():
		if input_dir == Vector2.ZERO:
			return

		velocity += input_dir * dash_speed
		dash_component.use_dash()
		EventManager.on_camera_shake.emit()
	else:
		EventManager.on_dash_error.emit()
		dash_component.dash_error()

func get_dash_count() -> int:
	return dash_component.dash_count
	
func apply_force(force) -> void:
	velocity += force

func absorb_galaxy(_data: GalaxyData) -> void:
	stabilization_component.add_time(5.0)

func _on_game_state_changed(state: GameWorld.GameState) -> void:
	match state:
		GameWorld.GameState.ONGOING:
			can_move = true
		GameWorld.GameState.PAUSED:
			can_move = false
		GameWorld.GameState.FINISHED:
			can_move = false
