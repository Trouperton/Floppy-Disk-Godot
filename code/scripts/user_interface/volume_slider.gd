extends HSlider


@export var bus_index: String = "Master"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_index), -60 + (60 * value/100))


func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_index), -60 + (60 * value/100))
