extends BaseUI


func _on_world_game_end(final_score: int) -> void:
	$Panel/VBoxContainer/ScoreDisplayLabel.text = str(final_score)
	show()
