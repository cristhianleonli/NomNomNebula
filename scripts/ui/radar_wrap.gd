class_name RadarWrap
extends TextureRect

var is_active: bool = true

func _process(delta):
	if not is_active: 
		return
	
	var player_vel = Globals.player.velocity
	
	var offset: Vector2 = self.material.get_shader_parameter("offset")
	offset += player_vel * delta * 0.001
	
	material.set_shader_parameter("offset", offset)

func stop_shader() -> void:
	is_active = false
