extends Node

var tank_shoot_audio_stream:AudioStreamOggVorbis = AudioStreamOggVorbis.load_from_file("res://sounds/games/tanks/shoot.ogg")
var small_explode_audio_stream:AudioStreamOggVorbis = AudioStreamOggVorbis.load_from_file("res://sounds/games/tanks/small_explosion.ogg")
var big_explode_audio_stream:AudioStreamOggVorbis = AudioStreamOggVorbis.load_from_file("res://sounds/games/tanks/big_explosion.ogg")
var countdown_3_sec_stream:AudioStreamOggVorbis = AudioStreamOggVorbis.load_from_file("res://sounds/interface/countdown_3_seconds.ogg")
var count_points_stream:AudioStreamOggVorbis = AudioStreamOggVorbis.load_from_file("res://sounds/interface/count_points.ogg")

enum GAME_AUDIO {
	TANK_SHOOT,
	TANK_SMALL_EXPLODE,
	TANK_BIG_EXPLODE,
	COUNTDOWN_3_SEC,
	COUNT_POINTS,
}

var game_audio_dict = [
	tank_shoot_audio_stream,
	small_explode_audio_stream,
	big_explode_audio_stream,
	countdown_3_sec_stream,
	count_points_stream,
]

func play_audio(audio: GAME_AUDIO):
	play_audio_at_pos(audio, Vector2(1152/2, 648/2))
	pass

func play_audio_at_pos(audio: GAME_AUDIO, pos: Vector2):
	var audio_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	audio_player.autoplay = true
	audio_player.stream = game_audio_dict[audio]
	audio_player.global_position = pos
	audio_player.finished.connect(_on_audio_finished.bind(audio_player))
	add_child(audio_player)
	
func _on_audio_finished(player: AudioStreamPlayer2D):
	player.queue_free()
	pass
