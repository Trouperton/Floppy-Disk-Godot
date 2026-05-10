extends Control


func _on_world_score_updated(current_score: int) -> void:
	$ScoreLabel.text = str(current_score)
