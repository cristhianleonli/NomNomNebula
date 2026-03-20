class_name GalaxyData
extends Resource

@export_category("Data")
@export var uid: String
@export var strength: int = 1
@export var size: float = 1.0
@export var stability_buff: float
@export var buff_debuff: Dictionary
@export var is_good_galaxy: bool

@export_category("Animation")
@export var animation: String
@export var halo_color1: Color
@export var halo_color2: Color
