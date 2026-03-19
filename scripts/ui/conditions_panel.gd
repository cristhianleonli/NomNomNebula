class_name ConditionsPanel
extends Node

@onready var texture_rect: TextureRect = $HBoxContainer/TextureRect
@onready var label: Label = $HBoxContainer/Label
@onready var tooltip_label: Label = $Tooltip/TooltipLabel
@onready var tooltip: Panel = $Tooltip

var atlas: AtlasTexture

func _ready() -> void:
	atlas = texture_rect.texture as AtlasTexture
	label.text = ""
	texture_rect.visible = false

func set_data(data: Dictionary) -> void:
	texture_rect.visible = true
	
	for key: String in data:
		if key == "rarity":
			pass
		elif key == "stability_max_count":
			if data["stability_max_count"] > 0:
				label.text = str(data["stability_max_count"])
				_set_icon(BuffDebuffKey.STABILITY_MAX)
		elif key == BuffDebuffKey.CONTROL_TYPE:
			label.text = ""
			_set_icon(key)
		elif key == BuffDebuffKey.STABILITY_MAX:
			pass
		else:
			_set_icon(key)
			label.text = _get_title(key, data[key])

func _set_icon(key: String) -> void:
	var new_region: Rect2 = atlas.region
	var tile_size: float = 32
	
	match key:
		BuffDebuffKey.EXTRA_DASHES:
			new_region.position.y = tile_size * 6.0
		BuffDebuffKey.DASH_FORCE_FACTOR:
			new_region.position.y = tile_size * 4.0
		BuffDebuffKey.ESCAPING_TIME:
			new_region.position.y = tile_size * 2.0
		BuffDebuffKey.DASH_RECHARGE_FACTOR:
			new_region.position.y = tile_size * 3.0
		BuffDebuffKey.MOVEMENT_WARP_FACTOR:
			new_region.position.y = tile_size * 0.0
		BuffDebuffKey.INTERACTION_RADIUS_FACTOR:
			new_region.position.y = tile_size * 1.0
		BuffDebuffKey.ABSORPTION_SPEED_FACTOR:
			new_region.position.y = tile_size * 5.0
		BuffDebuffKey.STABILITY_MAX:
			pass
		BuffDebuffKey.CONTROL_TYPE:
			pass
	
	atlas.region = new_region

func _get_title(key: String, value: Variant) -> String:
	match key:
		BuffDebuffKey.EXTRA_DASHES:
			return "+" + str(value)
		BuffDebuffKey.DASH_FORCE_FACTOR:
			return _get_float_format(value)
		BuffDebuffKey.ESCAPING_TIME:
			return "+" + str(value) + "s"
		BuffDebuffKey.DASH_RECHARGE_FACTOR:
			return _get_float_format(value)
		BuffDebuffKey.MOVEMENT_WARP_FACTOR:
			return _get_float_format(value)
		BuffDebuffKey.INTERACTION_RADIUS_FACTOR:
			return _get_float_format(value)
		BuffDebuffKey.ABSORPTION_SPEED_FACTOR:
			return _get_float_format(value)
		BuffDebuffKey.STABILITY_MAX:
			return ""
		BuffDebuffKey.CONTROL_TYPE:
			return ""
	
	return ""

func _get_float_format(value: float) -> String:
	var new_value: int = int(value * 100)
	var symbol: String = "" if new_value < 0 else "+"
	return symbol + str(new_value) + "%"
