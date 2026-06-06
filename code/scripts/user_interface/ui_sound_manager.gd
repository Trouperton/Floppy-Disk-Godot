extends Control


var focus_skipped: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().scene_changed.connect(_on_scene_changed)
	
	if get_tree().root.get_node("World").get_script() == LevelManager:
		print("binding end to pause")
		get_tree().root.get_node("World").game_end.connect(_on_game_paused_changed)
	
	find_buttons()
	find_pause_screen()


func _on_scene_changed() -> void:
	find_buttons()
	find_pause_screen()
	
	focus_skipped = false


func _on_button_button_down() -> void:
	$"Button Down Audio".play()


func _on_button_button_up() -> void:
	$"Button Up Audio".play()


func _on_button_pressed() -> void:
	$"Button Pressed Audio".play()
	$"Button Up Audio".stop()


func _on_button_focus_entered() -> void:
	if focus_skipped:
		$"Focus Audio".play()
	else:
		focus_skipped = true


func _on_button_mouse_entered() -> void:
	$"Hover Audio".play()


func _on_game_paused_changed(is_paused: bool):
	#print(name, " is_paused: ", is_paused)
	if is_paused:
		#print("playing pause sound")
		$"Pause Audio".play()
	else:
		#print("playing resume sound")
		focus_skipped = false
		$"Resume Audio".play()


func find_buttons():
	var temp_buttons = get_tree().get_nodes_in_group("button")
	
	for i in temp_buttons:
		var button: Button = i
		
		button.button_down.connect(_on_button_button_down)
		button.button_up.connect(_on_button_button_up)
		button.pressed.connect(_on_button_pressed)
		button.focus_entered.connect(_on_button_focus_entered)
		button.mouse_entered.connect(_on_button_mouse_entered)
	
	#print(temp_buttons.size())


func find_pause_screen():
	var pause_screen = get_tree().root.find_child("PauseScreen", true, false)
	
	if pause_screen != null:
		pause_screen.paused_changed.connect(_on_game_paused_changed)
