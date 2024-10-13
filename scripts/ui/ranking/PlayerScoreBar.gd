extends ColorRect

# Scores; updated from old_scores to scores
var score: int = 0
var old_score: int = 0

# Initial height of the collumn at score 0
var start_offset: int = 55

# Height of every segment
var score_segment_height: int = 20

# Number thatis shown at the bottom of the collumn
var display_score: int = 0

func _ready() -> void:
	# Set collumn height tho old_scores height and update display score
	custom_minimum_size.y = start_offset + (old_score * score_segment_height)
	display_score = old_score
	$TextScore.text = str(display_score)
	
	# Start with a random time offset
	var rand_start_time: float = randf_range(0.0, 0.5)
	await get_tree().create_timer(rand_start_time).timeout
	
	# Animate height and display number
	var tween_height: Tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	var tween_number: Tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween_height.tween_property(self, "custom_minimum_size", Vector2(custom_minimum_size.x, start_offset + (score * score_segment_height)), 3)
	tween_number.tween_property(self, "display_score", score, 3)
	pass

func _process(delta: float) -> void:
	# Update display number
	$TextScore.text = str(display_score)
	pass
