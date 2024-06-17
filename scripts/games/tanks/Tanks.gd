extends Node2D

var tank_player: PackedScene = load("res://scenes/games/tanks/PlayerTank.tscn")
var players_in_game: Array[int] = []

func _ready():
	$StartAnimation.animation_finished.connect(_on_animation_finished)
	
	var spawnpoints: Array[Node] = $Spawnpoints.get_children()
	for player in PlayerManager.players.values():
		players_in_game.append(player.id)
		var instance = tank_player.instantiate()
		instance.player = player
		var rand_index: int = randi() % spawnpoints.size()
		instance.global_position = spawnpoints[rand_index].global_position
		instance.rotation_degrees = randi() % 360
		instance.tank_exploded.connect(_on_tank_exploded)
		instance.shoot_bullet.connect(_on_shoot_bullet)
		spawnpoints[rand_index].queue_free()
		spawnpoints.remove_at(rand_index)
		$Players.add_child(instance)
	pass

func apply_shake():
	pass

func _on_tank_exploded(id: int, sender: CharacterBody2D):
	$Camera.apply_shake()
	players_in_game.erase(id)
	
	if players_in_game.size() == 1:
		$Bullets.queue_free()
		$Camera.zoom_to_winner(sender.global_position)
	pass

func _on_shoot_bullet(bullet: CharacterBody2D):
	$Bullets.add_child(bullet)

func _on_animation_finished():
	PlayerManager.locked = false
	pass
