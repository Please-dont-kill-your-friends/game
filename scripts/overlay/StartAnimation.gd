extends Control

signal animation_finished

func start_animation():
	SoundManager.play_audio(SoundManager.GAME_AUDIO.COUNTDOWN_3_SEC)
	$AnimationPlayer.play("countdown")

func _on_animation_player_animation_finished(_anim_name):
	animation_finished.emit()
	pass
