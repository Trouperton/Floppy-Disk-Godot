extends Control


var just_opened: bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().scene_changed.connect(_on_scene_changed)
	
	find_buttons()


func _on_scene_changed() -> void:
	find_buttons()


func _on_button_button_down() -> void:
	play_audio($"Button Down Audio")


func _on_button_button_up() -> void:
	play_audio($"Button Up Audio")


func _on_button_pressed() -> void:
	play_audio($"Button Pressed Audio")
	$"Button Up Audio".stop()


func _on_button_focus_entered() -> void:
	play_audio($"Focus Audio")


func _on_button_mouse_entered() -> void:
	play_audio($"Hover Audio")


func _on_game_paused() -> void:
	play_audio($"Pause Audio")


func _on_game_resume() -> void:
	play_audio($"Resume Audio")


func find_buttons():
	var temp_buttons = get_tree().get_nodes_in_group("button")
	
	for i in temp_buttons:
		var button: Button = i
		
		button.button_down.connect(_on_button_button_down)
		button.button_up.connect(_on_button_button_up)
		button.pressed.connect(_on_button_pressed)
		button.focus_entered.connect(_on_button_focus_entered)
		button.mouse_entered.connect(_on_button_mouse_entered)
	
	print(temp_buttons.size())


func play_audio(audio_player: AudioStreamPlayer):
	if just_opened:
		just_opened = false
	else:
		audio_player.play()
