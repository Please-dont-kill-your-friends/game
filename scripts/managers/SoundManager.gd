extends Node

var tank_shoot_audio_stream:AudioStreamOggVorbis = AudioStreamOggVorbis.load_from_file("res://sounds/games/tanks/shoot.ogg")
var small_explode_audio_stream:AudioStreamOggVorbis = AudioStreamOggVorbis.load_from_file("res://sounds/games/tanks/small_explosion.ogg")
var big_explode_audio_stream:AudioStreamOggVorbis = AudioStreamOggVorbis.load_from_file("res://sounds/games/tanks/big_explosion.ogg")

enum GAME_AUDIO {
	TANK_SHOOT,
	TANK_SMALL_EXPLODE,
	TANK_BIG_EXPLODE,
}

var game_audio_dict = [
	tank_shoot_audio_stream,
	small_explode_audio_stream,
	big_explode_audio_stream,
]

func play_audio_at_pos(audio: GAME_AUDIO, pos: Vector2, parent: Node):
	var audio_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	audio_player.autoplay = true
	audio_player.stream = game_audio_dict[audio]
	audio_player.global_position = pos
	audio_player.finished.connect(_on_audio_finished.bind(audio_player))
	parent.add_child(audio_player)
	
func _on_audio_finished(player: AudioStreamPlayer2D):
	player.queue_free()
	pass
