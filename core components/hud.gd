extends CanvasLayer

# Current score
var score: int = 0

# Updates the score displayed on the HUD
func update_score(new_score: int) -> void:
	if new_score > score:
		score = new_score
		$ScoreLabel.text = "Descent: " + str(score)
