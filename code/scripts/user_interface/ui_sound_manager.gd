extends Control


var just_opened: bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_parent() is not Control:
		printerr("Parent is not UI")


func play_audio(audio_player: AudioStreamPlayer):
	if just_opened:
		just_opened = false
	else:
		audio_player.play()


func _on_hidden() -> void:
	just_opened = true


func _on_button_focus_entered() -> void:
	play_audio($"Focus Audio")


func _on_button_mouse_entered() -> void:
	play_audio($"Hover Audio")


func _on_button_button_down() -> void:
	play_audio($"Button Down Audio")


func _on_button_button_up() -> void:
	play_audio($"Button Up Audio")


func _on_button_pressed() -> void:
	play_audio($"Button Pressed Audio")
