extends HSlider


@export var audio_bus: AudioBusLayout
@export var index: String = "Master"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_drag_ended(value_changed: bool) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(index), -60 + (60 * value/100))
	print(index, ": volume has been set to " + str(-60 + (60 * value/100)) + "db")
