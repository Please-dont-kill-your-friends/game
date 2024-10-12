extends Control

var player_score_bar: PackedScene = load("res://scenes/ranking/PlayerScoreBar.tscn")

func _ready() -> void:
	for player in PlayerManager.players.values():
		var instance = player_score_bar.instantiate()
		instance.color = ColorManager.get_color(player.color)
		instance.score = ScoreManager.scores[player.id]
		instance.old_score = ScoreManager.old_scores[player.id]
		$ScoreBarContainer.add_child(instance)
	pass
