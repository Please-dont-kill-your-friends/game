extends Button

func _on_pressed():
	CommunicationManager.sever_send_scene_change.rpc()
	get_tree().change_scene_to_file("res://scenes/games/tanks/Tanks.tscn")
	pass 
