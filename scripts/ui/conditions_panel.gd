class_name ConditionsPanel
extends Node

@onready var texture_rect: TextureRect = $HBoxContainer/TextureRect
@onready var label: Label = $HBoxContainer/Label
@onready var tooltip_label: Label = $Tooltip/TooltipLabel
@onready var tooltip: PanelContainer = $Tooltip

var atlas: AtlasTexture

func _ready() -> void:
	atlas = texture_rect.texture as AtlasTexture
	label.text = ""
	texture_rect.visible = false
	tooltip.visible = false
	
	texture_rect.mouse_exited.connect(func() -> void: tooltip.visible = false)
	texture_rect.mouse_entered.connect(func() -> void:
		tooltip.visible = true
		AudioManager.play_sfx(AudioManager.tracks.show_ui)
	)

func set_data(data: Dictionary) -> void:
	texture_rect.visible = true
	label.text = ""
	tooltip_label.text = ""
	
	for key: String in data:
		if key == "rarity":
			pass
		elif key == BuffDebuffKey.CONTROL_TYPE_TANK or key == BuffDebuffKey.CONTROL_TYPE_INVERTED:
			label.text = ""
			_set_icon(key)
			_set_tooltip_title(key)
		else:
			label.text = _get_title(key, data[key])
			_set_icon(key)
			_set_tooltip_title(key)

func _set_tooltip_title(key: String) -> void:
	tooltip_label.text = BuffDebuffKey.DESCRIPTIONS.get(key, "-")
	
func _set_icon(key: String) -> void:
	var new_region: Rect2 = atlas.region
	var tile_size: float = 32
	
	match key:
		BuffDebuffKey.EXTRA_DASHES:
			new_region.position.y = tile_size * 6.0
		BuffDebuffKey.LIMIT_DASH:
			new_region.position.y = tile_size * 6.0 # FIXME: new icon
		BuffDebuffKey.DASH_FORCE_FACTOR:
			new_region.position.y = tile_size * 4.0
		BuffDebuffKey.ESCAPING_TIME:
			new_region.position.y = tile_size * 2.0
		BuffDebuffKey.DASH_RECHARGE_FACTOR:
			new_region.position.y = tile_size * 3.0
		BuffDebuffKey.DASH_RECHARGE_FACTOR_INCREASED:
			new_region.position.y = tile_size * 3.0 # FIXME: new icon
		BuffDebuffKey.MOVEMENT_WARP_FACTOR:
			new_region.position.y = tile_size * 0.0
		BuffDebuffKey.INTERACTION_RADIUS_FACTOR:
			new_region.position.y = tile_size * 1.0
		BuffDebuffKey.ABSORPTION_SPEED_FACTOR:
			new_region.position.y = tile_size * 5.0
		BuffDebuffKey.STABILITY_MAX:
			new_region.position.y = tile_size * 5.0 # FIXME: new icon
		BuffDebuffKey.CONTROL_TYPE_TANK:
			new_region.position.y = tile_size * 5.0 # FIXME: new icon
		BuffDebuffKey.CONTROL_TYPE_INVERTED:
			new_region.position.y = tile_size * 5.0 # FIXME: new icon
	
	atlas.region = new_region

func _get_title(key: String, value: Variant) -> String:
	match key:
		BuffDebuffKey.EXTRA_DASHES:
			return "+" + str(value)
		BuffDebuffKey.LIMIT_DASH:
			return str(value)
		BuffDebuffKey.DASH_FORCE_FACTOR:
			return _get_float_format(value)
		BuffDebuffKey.ESCAPING_TIME:
			return "+" + str(value) + "s"
		BuffDebuffKey.DASH_RECHARGE_FACTOR:
			return _get_float_format(value)
		BuffDebuffKey.DASH_RECHARGE_FACTOR_INCREASED:
			return _get_float_format(value)
		BuffDebuffKey.MOVEMENT_WARP_FACTOR:
			return _get_float_format(value)
		BuffDebuffKey.INTERACTION_RADIUS_FACTOR:
			return _get_float_format(value)
		BuffDebuffKey.ABSORPTION_SPEED_FACTOR:
			return _get_float_format(value)
		BuffDebuffKey.STABILITY_MAX:
			return str(value)
		BuffDebuffKey.CONTROL_TYPE_TANK:
			return ""
		BuffDebuffKey.CONTROL_TYPE_INVERTED:
			return ""
	
	return ""

func _get_float_format(value: float) -> String:
	var new_value: int = int(value * 100)
	var symbol: String = "" if new_value < 0 else "+"
	return symbol + str(new_value) + "%"
