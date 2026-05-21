extends BaseUI


signal paused_changed(is_paused: bool)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") and !$"../EndScreen".visible:
		visible = !visible


func _on_visibility_changed() -> void:
	super._on_visibility_changed()
	if visible:
		paused_changed.emit(true)
		get_tree().paused = true
		$Panel2/VBoxContainer/ScoreDisplayLabel.text = str($"..".score)
	else:
		if get_parent() != null:
			paused_changed.emit(false)
			get_tree().paused = false
