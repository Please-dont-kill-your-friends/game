extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func start_game():
	ScoreManager.init_scores()
	CommunicationManager.sever_send_scene_change.rpc()
	get_tree().change_scene_to_file("res://scenes/games/tanks/Tanks.tscn")
	pass
