extends Node

var scores: Dictionary = {}
var old_scores: Dictionary = {}

# Initialize every score to 0
func init_scores() -> void:
	for player in PlayerManager.players.values():
		scores[player.id] = 0
	pass

# Update scores and show ranking screen
func update_scores(winner_points: Dictionary) -> void:
	old_scores = scores.duplicate()
	for winner in winner_points:
		scores[winner] += winner_points[winner]
	
	_show_ranking_screen()
	pass

func _show_ranking_screen() -> void:
	get_tree().change_scene_to_file("res://scenes/ranking/Ranking.tscn")
	pass
