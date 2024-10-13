extends Node
class_name Game

var player_scores: Dictionary = {}

func _ready() -> void:
	_init_game()
	_init_scores()
	_update_controller()
	_start_game()
	pass

# Will be overwritten in game code
func _init_game():
	pass

func _init_scores():
	for player in PlayerManager.players.values():
		player_scores[player.id] = 0
	pass

# Will be overwritten in game code
func _update_controller():
	pass

# Start Game
func _start_game():
	pass

# Finish Game
func _stop_game(winner_id: int):
	player_scores[winner_id] += 2
	ScoreManager.update_scores(player_scores)
	pass
