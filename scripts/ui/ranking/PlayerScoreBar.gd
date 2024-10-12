extends ColorRect

var start_offset = 55
@export var old_score: int = 0
@export var score: int = 0
var display_score = 0
var last_score = 0
var score_segment_height = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	custom_minimum_size.y = start_offset + (old_score * score_segment_height)
	display_score = old_score
	$TextScore.text = str(display_score)
	
	var rand_start_time: float = randf_range(0.0, 0.5)
	await get_tree().create_timer(rand_start_time).timeout
	
	var tween_height = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	var tween_number = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween_height.tween_property(self, "custom_minimum_size", Vector2(custom_minimum_size.x, start_offset + (score * score_segment_height)), 3)
	tween_number.tween_property(self, "display_score", score, 3)
	pass

func _process(delta: float) -> void:
	if last_score != display_score:
		$TextScore.text = str(display_score)
		last_score = display_score
	pass
