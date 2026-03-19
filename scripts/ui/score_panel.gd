class_name ScorePanel
extends Node

const INCREMENT_LABEL: PackedScene = preload("uid://l438c6qr6470")

@onready var score_label: Label = $ScoreLabel
@onready var marker_2d: Marker2D = $Marker2D

var tween: Tween
var initial_pos: Vector2

func _ready() -> void:
	score_label.text = str(Globals.current_score)

func increment_score(value: int) -> void:
	var node: IncrementLabel = INCREMENT_LABEL.instantiate()
	add_child(node)
	node.text = "+" + str(value)
	node.position = marker_2d.position
	node.animate()
	score_label.text = str(Globals.current_score)
