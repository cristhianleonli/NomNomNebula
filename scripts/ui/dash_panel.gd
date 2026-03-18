class_name DashPanel
extends Node

@onready var h_box_container: HBoxContainer = $HBoxContainer
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var animation_component: AnimationComponent = $AnimationComponent
@onready var texture_rect: TextureRect = $TextureRect

var slot_count: int = 0
var remaning: int = 0
var is_recharging: bool = false

func _ready() -> void:
	EventManager.on_dash_recover_progress.connect(_on_dash_recharging)
	EventManager.on_dash_udpated.connect(_on_dash_udpated)

func setup(max_dashes: int) -> void:
	slot_count = max_dashes
	remaning = max_dashes
	
	_refresh_slots()
	_update()

func _on_dash_udpated(data: Dictionary) -> void:
	var dash_count: int = data.get("count", 0)
	var dash_max: int = data.get("max", 0)
	
	slot_count = dash_max
	remaning = dash_count
	
	_refresh_slots()
	_update()

#func _set_max_dashes(amount: int) -> void:
	#slot_count = amount
	#
	#if remaning > slot_count:
		#remaning = slot_count
	#
	#_refresh_slots()
	#_update()

func _process(_delta: float) -> void:
	progress_bar.visible = is_recharging

func _refresh_slots() -> void:
	for node in h_box_container.get_children():
		node.visible = false
	
	for i in range(min(slot_count, h_box_container.get_child_count())):
		h_box_container.get_child(i).visible = true

func _update() -> void:
	for i in range(min(slot_count, h_box_container.get_child_count())):
		h_box_container.get_child(i).color = Color.WHITE
		
	for i in range(min(remaning, h_box_container.get_child_count())):
		var node = h_box_container.get_child(i)
		node.visible = true
		node.color = Color.GREEN

#func _on_dash_used() -> void:
	#remaning = max(remaning - 1, 0)
	#_refresh_slots()
	#_update()
	#animation_component.subtle_wobble(texture_rect)

#func _on_dash_recovered() -> void:
	#remaning = slot_count
	#is_recharging = false
	#_refresh_slots()
	#_update()

func _on_dash_recharging(progress: float) -> void:
	is_recharging = true
	progress_bar.value = progress * 100
