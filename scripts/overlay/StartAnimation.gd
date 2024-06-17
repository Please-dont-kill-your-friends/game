extends Control

signal animation_finished

func _on_animation_player_animation_finished(anim_name):
	animation_finished.emit()
	pass
