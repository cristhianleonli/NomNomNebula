extends Node

@onready var dash_panel: DashPanel = $CanvasLayer/DashPanel
@onready var player_test: Player = $PlayerTest

func _ready() -> void:
	dash_panel.setup(player_test.get_dash_count())
	
	SceneManager.fade_in()
