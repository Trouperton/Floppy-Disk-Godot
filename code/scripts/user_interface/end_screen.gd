extends Control


func _on_visibility_changed() -> void:
	if visible:
		$Panel/VBoxContainer/RestartButton.grab_focus()


func _on_world_game_end(final_score: int) -> void:
	$Panel/VBoxContainer/ScoreDisplayLabel.text = str(final_score)
	show()
