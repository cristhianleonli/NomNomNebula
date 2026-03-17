extends ColorRect

# Called when the node enters the scene tree for the first time.

@export var shock_wave_speed : float = 10.0
@export var shock_wave_center : Vector2 = Vector2(0.5, 0.5)
@export var shock_wave_force : float = 0.5

var shock_wave_size : float = 2.0

func _ready() -> void:
	EventManager.on_shock_wave.connect(start_shock_wave)

func start_shock_wave() -> void:
	shock_wave_size = -0.1
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shock_wave_size < 2:
		shock_wave_size += shock_wave_speed*delta
		self.material.set_shader_parameter("size", shock_wave_size)
