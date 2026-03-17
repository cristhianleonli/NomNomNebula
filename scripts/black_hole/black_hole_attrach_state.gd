class_name BlackHoleAttrach
extends State

@export var attraction_area: Area2D
@export var black_hole : BlackHole
@export var normal_time : float = 2.0 #Chage variable name
@export var strenght : float = 3.0

@onready var camera: Camera2D = get_tree().get_first_node_in_group("main_camera")

var last_dash_used_time : float
var strong_attrach_start_time : float

var timer: float

func enter() -> void:
	timer = 5
	attraction_area.area_exited.connect(on_exited_area)
	EventManager.on_dash_used.connect(on_player_dash_used)
	EventManager.on_attraching_player.emit()
	camera.target_zoom = Vector2(0.4, 0.4)
	camera.set_target(black_hole)

func update(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		strong_attrach_start_time = Time.get_ticks_msec()/1000.0
		strenght = 5.0
	var force : Vector2 = calc_force()
	Globals.player.apply_force(force)
	
	black_hole.timer_label.text = "%.2f" % timer

func on_exited_area(_area:Area2D) -> void:
	change_state.emit(self, "blackholeidle")
	
func exit() -> void:
	attraction_area.area_exited.disconnect(on_exited_area)
	EventManager.on_dash_used.disconnect(on_player_dash_used)
	camera.set_target(Globals.player)
	
func calc_force() -> Vector2:
	var offset: Vector2 = get_offset_to_player()
	var dir: Vector2 = offset.normalized()
	return dir * strenght/(offset.length()*0.01)
	
func get_offset_to_player() -> Vector2:
	return black_hole.global_position - Globals.player.global_position
	
func on_player_dash_used():
	last_dash_used_time = Time.get_ticks_msec()/1000.0
	if timer < 1.0 or abs(last_dash_used_time - strong_attrach_start_time) < 1:
		print('a')
