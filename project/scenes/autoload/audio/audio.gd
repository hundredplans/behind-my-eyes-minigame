extends Node

enum Places {NULL, MAIN_MENU, COMBAT, LOSS}
@onready var MusicTimer: Timer = %MusicTimer
@onready var MusicPlayer: AudioStreamPlayer = %MusicPlayer

@export var loss_music: AudioStream
@export var main_menu_music: AudioStream
@export var combat_music: AudioStream
@export var music_volume: float
@export var music_fade_time: float
@export var music_faded_volume: float

const SFX_OFFSET: float = 0.1

var MusicVolumeTween: Tween
var place: Places

func _ready() -> void:
	MusicPlayer.volume_db = music_volume
	MusicTimer.timeout.connect(onMusicTimerTimeout)

func onPlaySFX(sfx: AudioStream, use_offset: bool = false, custom_pitch: float = 1.0) -> AudioStreamPlayer:
	var audio_stream_player := AudioStreamPlayer.new()
	audio_stream_player.bus = "SFX"
	add_child(audio_stream_player)
	audio_stream_player.pitch_scale = custom_pitch
	audio_stream_player.stream = sfx
	audio_stream_player.finished.connect(audio_stream_player.queue_free)
	onPlayWithOffset(audio_stream_player, use_offset)
	return audio_stream_player
	
func onPlayMusic() -> void:
	MusicPlayer.stream = getMusicFromPlace()
	MusicPlayer.volume_db = music_faded_volume
	if MusicPlayer.stream == null: return
	if MusicVolumeTween: MusicVolumeTween.kill()
	MusicVolumeTween = create_tween()
	
	MusicVolumeTween.tween_property(MusicPlayer, "volume_db", music_volume, music_fade_time)
	MusicTimer.wait_time = MusicPlayer.stream.get_length() - music_fade_time
	MusicTimer.start()
	
	MusicPlayer.play()

func onPlayWithOffset(audio_stream_player: Variant, use_offset: bool) -> void:
	if use_offset:
		await get_tree().create_timer(randf_range(0.0, SFX_OFFSET)).timeout
	audio_stream_player.play()

func onMusicTimerTimeout() -> void:
	if MusicVolumeTween: MusicVolumeTween.kill()
	MusicVolumeTween = create_tween()
	MusicVolumeTween.tween_property(MusicPlayer, "volume_db", music_faded_volume, music_fade_time)
	await MusicVolumeTween.finished
	onPlayMusic()

func setPlace(_place: Places) -> void:
	if place == _place: return
	place = _place
	onPlayMusic()

func getMusicFromPlace() -> AudioStream:
	match place:
		Places.COMBAT: return combat_music
		Places.MAIN_MENU: return main_menu_music
		Places.LOSS: return loss_music
	return null
