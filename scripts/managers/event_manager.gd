extends Node

@warning_ignore_start("unused_signal")
@warning_ignore_start("untyped_declaration")

#region GameClock
signal on_world_ready

signal on_galaxy_collided(data: GalaxyData)
#endregion

@warning_ignore_restore("unused_signal")
@warning_ignore_restore("untyped_declaration")
