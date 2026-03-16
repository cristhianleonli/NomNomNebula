class_name DashComponent
extends Node

var base_dashes: int = 2
var bonus_dashes: int = 0

var recharge_time_per_use: float = 1.0

var dash_count: int
var recharging: bool = false
var recharge_elapsed: float = 0.0
var recharge_time: float

var dash_delay: float = 0.5
var dash_delay_timer: float = 0.0

func _ready() -> void:
	dash_count = get_max_dashes()
	_update_recharge_time()

func get_max_dashes() -> int:
	return base_dashes + bonus_dashes

func _update_recharge_time() -> void:
	recharge_time = get_max_dashes() * recharge_time_per_use

func can_dash() -> bool:
	return dash_count > 0 and not recharging and dash_delay_timer <= 0

func use_dash() -> void:
	if not can_dash():
		return

	dash_count -= 1
	dash_delay_timer = dash_delay
	
	EventManager.on_dash_used.emit()
	AudioManager.play_sfx(AudioManager.tracks.dash)

	if dash_count == 0:
		_start_recharge()

func dash_error() -> void:
	AudioManager.play_sfx(AudioManager.tracks.dash_error)

func add_temp_dashes(amount: int) -> void:
	bonus_dashes += amount
	dash_count += amount
	
	_update_recharge_time()
	EventManager.on_dash_fully_recovered.emit()

func add_permanent_dashes(amount: int) -> void:
	base_dashes += amount
	dash_count += amount
	
	_update_recharge_time()
	EventManager.on_dash_fully_recovered.emit()

func _start_recharge() -> void:
	if recharging:
		return

	recharging = true
	recharge_elapsed = 0.0

	EventManager.on_dash_recover_progress.emit(0.0)
	AudioManager.play_sfx(AudioManager.tracks.dash_empty)

func _process(delta: float) -> void:
	if dash_delay_timer > 0:
		dash_delay_timer -= delta

	if not recharging:
		return

	recharge_elapsed += delta

	var progress: float = recharge_elapsed / recharge_time
	EventManager.on_dash_recover_progress.emit(clamp(progress, 0.0, 1.0))

	if recharge_elapsed >= recharge_time:
		recharge_elapsed = 0.0
		recharging = false
		
		dash_count = get_max_dashes()
		bonus_dashes = 0
		
		EventManager.on_dash_fully_recovered.emit()
		AudioManager.play_sfx(AudioManager.tracks.dash_recovered)
