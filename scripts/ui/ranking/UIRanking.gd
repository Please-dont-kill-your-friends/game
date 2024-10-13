extends Control

var player_score_bar: PackedScene = load("res://scenes/ranking/PlayerScoreBar.tscn")

func _ready() -> void:
	# Instanciate a player score bar for every player with its scores
	for player in PlayerManager.players.values():
		var instance = player_score_bar.instantiate()
		instance.color = ColorManager.get_color(player.color)
		instance.score = ScoreManager.scores[player.id]
		instance.old_score = ScoreManager.old_scores[player.id]
		$ScoreBarContainer.add_child(instance)
	
	_calculate_rank()
	
	await get_tree().create_timer(3 + 0.5 + 5).timeout 
	GameManager.start_next_game()
	pass

func _calculate_rank() -> void:
	# Sort all Players by rank
	var sorted_player_ids = ScoreManager.scores.keys()
	sorted_player_ids.sort_custom(func(a,b):
		return ScoreManager.scores[b] < ScoreManager.scores[a]
		# Character ">" would be ascending, "<" is descending
	)
	
	var last_points = -1  # Initialize to an invalid score
	var rank = 1  # Start ranking from 1
	var places = []  # Stores ranks for players
	
	for i in range(sorted_player_ids.size()):
		var player_id = sorted_player_ids[i]
		var player_score = ScoreManager.scores[player_id]
		
		# If the player's score is different from the last, increment the rank
		if player_score != last_points:
			rank = i + 1  # Correctly assigns the rank based on position in sorted list	
			
		places.append(rank)  # Append the current rank
		last_points = player_score  # Update last_points to the current player's score
	
	for i in range(sorted_player_ids.size()):
		CommunicationManager.server_send_ranking.rpc_id(sorted_player_ids[i], places[i], ScoreManager.scores[sorted_player_ids[i]])
	pass
