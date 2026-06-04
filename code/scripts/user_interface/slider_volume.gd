extends HSlider


@export var bus_index: String = "Master"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bus_volume_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus_index))
	
	if bus_volume_db == 0:
		value = 100
	else:
		value = (bus_volume_db + 60) / 60 * 100


func _on_value_changed(new_value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_index), -60 + (60 * new_value/100))
