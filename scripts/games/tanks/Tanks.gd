extends Game

var tank_player: PackedScene = load("res://scenes/games/tanks/PlayerTank.tscn")
var players_in_round: Array[int] = []
const ROUNDS_TO_WIN: int = 3

func _update_controller():
	CommunicationManager.sever_set_controller_joystick.rpc()
	pass

func _init_game():
	$StartAnimation.animation_finished.connect(_on_animation_finished)
	pass

func _start_game():
	_start_round()
	pass

func _start_round():
	# Spawn players and start round after all players are spawned
	_spawn_players()
	$StartAnimation.start_animation()
	pass

func _spawn_players():
	# Clear players from previous round
	players_in_round.clear()
	
	# Initialize Spawnpoints
	var spawnpoints: Array[Node] = $Spawnpoints.get_children()
	var already_spawned_at: Array[int] = []
	
	# Spawn players
	for player in PlayerManager.players.values():
		# Find a spawn position, that isn't in use
		var random_index: int = randi() % spawnpoints.size()
		while random_index in already_spawned_at:
			random_index = randi() % spawnpoints.size()
		
		# Create new instance of TankPlayer
		# Sets location, rotation and connects signals
		var instance = tank_player.instantiate()
		instance.player = player
		instance.global_position = spawnpoints[random_index].global_position
		instance.rotation_degrees = randi() % 360
		instance.tank_exploded.connect(_on_tank_exploded)
		instance.shoot_bullet.connect(_on_shoot_bullet)
		$Players.add_child(instance)
		
		# Updates Arrays and disables the shoot button
		players_in_round.append(player.id)
		already_spawned_at.append(random_index)
		CommunicationManager.server_disable_button_a.rpc_id(player.id, true)
	pass

func _check_win(sender: CharacterBody2D):
	if players_in_round.size() == 1:
		CommunicationManager.server_disable_button_a.rpc(true)
		
		for bullet in $Bullets.get_children():
			$Bullets.remove_child(bullet)
			bullet.queue_free()
		
	player_scores[players_in_round[0]] += 1
	$Camera.zoom_to_winner(sender.global_position)
	await get_tree().create_timer(3.0).timeout
	
	if player_scores.get(_get_higest_ranking_player()) == ROUNDS_TO_WIN:
		_stop_game(_get_higest_ranking_player())
	else:
		_stop_round()
		_start_round()
	pass

func _stop_round():
	for player in $Players.get_children():
		$Players.remove_child(player)
		player.queue_free() 
		
	$Camera.zoom_out()
	PlayerManager.locked = true
	pass

func _get_higest_ranking_player() -> int:
	# Sort all Players by rank
	var sorted_player_scores = player_scores.keys()
	sorted_player_scores.sort_custom(func(a,b):
		return player_scores[b] < player_scores[a]
		# Character ">" would be ascending, "<" is descending
	)
	
	# Get higest ranking Player
	return sorted_player_scores[0]

func _on_tank_exploded(id: int, sender: CharacterBody2D):
	$Camera.apply_shake()
	players_in_round.erase(id)
	
	_check_win(sender)
	pass

func _on_shoot_bullet(bullet: CharacterBody2D):
	$Bullets.add_child(bullet)

func _on_animation_finished():
	PlayerManager.locked = false
	CommunicationManager.server_disable_button_a.rpc(false)
	pass
