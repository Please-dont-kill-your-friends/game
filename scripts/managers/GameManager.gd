extends Node

# Played Games
var played_games: Array[int] = []
var current_game: GAMES

# Loading Screen
var loading_screen_scene: PackedScene = load("res://scenes/loading_screen/LoadingScreen.tscn")

# Availible Game Scenes
var tank_game_scene: PackedScene = load("res://scenes/games/tanks/Tanks.tscn")

enum GAMES {
	TANKS,
}

var game_scenes: Array[PackedScene] = [
	tank_game_scene
]

var loading_screen_values: Array = [
	["Tanks", "Shoot at the other Tanks. First to survive 3 rounds wins the game.", "res://images/loading_screens/tanks_loading_screen.png"]
]

# Start Game Loop
func start_game_loop() -> void:
	ScoreManager.init_scores()
	start_next_game()
	pass

# Play next game
func start_next_game() -> void:
	if played_games.size() == GAMES.size():
		print("Game Limit exceeded")
		return
	
	current_game = _choose_unique_game()
	get_tree().change_scene_to_packed(loading_screen_scene)
	await get_tree().create_timer(10).timeout
	get_tree().change_scene_to_packed(game_scenes[current_game])
	pass

# Choose unique Game to play
func _choose_unique_game() -> int:
	var game: GAMES = randi() % GAMES.size()
	while game in played_games:
		game = randi() % GAMES.size()
	# played_games.append(game)
	return game
