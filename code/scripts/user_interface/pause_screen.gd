extends BaseUI


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") and !$"../EndScreen".visible:
		visible = !visible


func _on_visibility_changed() -> void:
	super._on_visibility_changed()
	if visible:
		get_parent().get_tree().paused = true
		$Panel2/VBoxContainer/ScoreDisplayLabel.text = str($"..".score)
	else:
		if get_parent() != null:
			get_parent().get_tree().paused = false
