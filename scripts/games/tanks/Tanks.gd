extends Node2D

var tank_player: PackedScene = load("res://scenes/games/tanks/PlayerTank.tscn")
var player_scores: Dictionary = {}
var players_in_round: Array[int] = []

func _ready():
	$StartAnimation.animation_finished.connect(_on_animation_finished)
	
	_init_scores()
	_spawn_players()
	pass

func _init_scores():
	for player in PlayerManager.players.values():
		player_scores[player.id] = 0
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
	
	# Start round after all players are spawned
	$StartAnimation.start_animation()
	pass

func _spawn_player():
	pass

func _check_win():
	player_scores[players_in_round[0]] += 1
	
	var sorted_player_scores = player_scores.keys()
	sorted_player_scores.sort_custom(func(a,b):
		return player_scores[b] < player_scores[a]
		# Character ">" would be ascending, "<" is descending
	)
	
	var winning_player = sorted_player_scores[0]
	if player_scores.get(winning_player) == 3:
		ScoreManager.update_scores(player_scores)
	else:
		for child in $Players.get_children():
			$Players.remove_child(child)
			child.queue_free() 
		
		$Camera.zoom_out()
		_spawn_players()
		PlayerManager.locked = false
	pass

func _on_tank_exploded(id: int, sender: CharacterBody2D):
	$Camera.apply_shake()
	players_in_round.erase(id)
	
	if players_in_round.size() == 1:
		PlayerManager.locked = true
		CommunicationManager.server_disable_button_a.rpc_id(players_in_round[0], true)
		for bullet in $Bullets.get_children():
			$Bullets.remove_child(bullet)
			bullet.queue_free()
		$Camera.zoom_to_winner(sender.global_position)
		
		await get_tree().create_timer(3.0).timeout
		
		_check_win()
	pass

func _on_shoot_bullet(bullet: CharacterBody2D):
	$Bullets.add_child(bullet)

func _on_animation_finished():
	PlayerManager.locked = false
	CommunicationManager.server_disable_button_a.rpc(false)
	pass
