class_name GalaxyInfoPanel
extends Node

@onready var data_label: Label = $DataLabel

func _ready() -> void:
	self.visible = false

func present(data: GalaxyData) -> void:
	self.visible = true
	
	var lines: Array[String] = []
	
	lines.append("uid: " + data.uid)
	lines.append("Stability buff: " + str(data.stability_buff))
	
	for key in data.buff_debuff:
		var value: String = str(data.buff_debuff[key])
		
		if key == "rarity":
			value = ["COMMON", "UNCOMMON", "RARE"][data.buff_debuff[key]]
		
		var line: String = key + " : " + value
		lines.append(line)
	
	data_label.text = "\n".join(lines)

func dismiss() -> void:
	self.visible = false
