extends Control
@onready var logo: Sprite2D = %Logo

@onready var audio: AudioStreamPlayer = %Audio

const sound = preload("res://assets/audio/Storskogen splashscreen.wav")

func _ready() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(logo, "position", Vector2.ZERO, 2.0)
	
	await tween.finished
	
	audio.stream = sound
	audio.play()
	
	await get_tree().create_timer(3.0).timeout
	
	_next_scene()


func _input(event: InputEvent) -> void:
	if (event is not InputEventMouseMotion and event is not InputEventJoypadMotion and event.is_pressed()):
		_next_scene()

func _next_scene():
	get_tree().change_scene_to_file("res://game_splash.tscn")
