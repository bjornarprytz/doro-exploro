extends Node2D

signal beat(number: int)

var order: Array[String] = []
var _streamPlayers: Dictionary[String, AudioStreamPlayer] = {}

@onready var main: AudioStreamPlayer = %Main

const tempo: int = 102
const intro = preload("res://assets/audio/SoundshipSPACE_.wav")

var maestro: AudioStreamPlayer

var instruments: Array[AudioStream] = [
	preload("res://assets/audio/symphony/Soundship01.wav"),
	preload("res://assets/audio/symphony/Soundship02.wav"),
	preload("res://assets/audio/symphony/Soundship03.wav"),
	preload("res://assets/audio/symphony/Soundship04.wav"),
	preload("res://assets/audio/symphony/Soundship05.wav"),
	preload("res://assets/audio/symphony/Soundship06.wav"),
	preload("res://assets/audio/symphony/Soundship07.wav"),
	preload("res://assets/audio/symphony/Soundship08.wav"),
	preload("res://assets/audio/symphony/Soundship09.wav"),
	preload("res://assets/audio/symphony/Soundship10.wav"),
	preload("res://assets/audio/symphony/Soundship11.wav"),
	preload("res://assets/audio/symphony/Soundship12.wav"),
	preload("res://assets/audio/symphony/Soundship13.wav"),
	preload("res://assets/audio/symphony/Soundship14.wav"),
	preload("res://assets/audio/symphony/Soundship15.wav")
]

var beat_number: int = 0
var time_counter: float = 0.0
var seconds_per_beat: float = 60.0 / tempo

var start_beat = false
func _process(delta: float) -> void:
	if !start_beat:
		return
	time_counter += delta
	if time_counter > seconds_per_beat:
		time_counter -= seconds_per_beat
		beat_number += 1
		beat.emit(beat_number)

func start_intro():
	main.volume_db = 0.0
	main.stream = intro
	main.play()

# Make sure it stays in sync
func _restart_beat():
	time_counter = 0.0
	beat_number = 0

func full_ensemble():
	while (instruments.size() > 0):
		add_instrument()

func add_instrument():
	if (main.playing):
		var tween = create_tween()
		tween.tween_property(main, "volume_db", -80.0, 1.69)
		tween.tween_callback(main.stop)
	if (instruments.size() == 0):
		print("Found all instruments already")
		return
	
	# Star the beat along with the first instrument
	
	var player = AudioStreamPlayer.new()
	add_child(player)
	
	if _streamPlayers.size() == 0:
		start_beat = true
		time_counter = 0.0
		player.finished.connect(_restart_beat)
	var instrument = instruments.pop_front() as AudioStream
		
	var key = instrument.resource_path
	_streamPlayers[key] = player
	order.push_back(key)
	var current_playback_position: float = 0.0
	if (maestro != null):
		current_playback_position = maestro.get_playback_position()
	else:
		maestro = player
	
	player.stream = instrument
	player.play(current_playback_position)
	maestro.finished.connect(player.play.bind(0.0))

func pop_instrument() -> bool:
	if (order.size() == 0):
		return false
	var key = order.pop_back()
	var player = _streamPlayers[key]
	player.stop()
	instruments.push_back(player.stream)
	_streamPlayers.erase(key)
	player.queue_free()
	if (_streamPlayers.size() == 0):
		start_beat = false
		time_counter = 0.0
		return false
	
	return true
