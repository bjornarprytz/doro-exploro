extends Control

@onready var logo: Sprite2D = %Logo
@onready var controls: TextureRect = %Controls
@onready var fade: ColorRect = $Fade


func _ready() -> void:
	Symphony.start_intro()
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(logo, "scale", Vector2.ONE, 2.0)
	
	await tween.finished
	controls.visible = true
	await get_tree().create_timer(5.0).timeout

	_next_scene()
	


func _input(event: InputEvent) -> void:
	if (event is not InputEventMouseMotion and event is not InputEventJoypadMotion and event.is_pressed()):
		_next_scene()

var next_scene_init = false
func _next_scene():
	if (next_scene_init):
		return
	next_scene_init = true
	var tween = create_tween()
	fade.show()
	fade.modulate.a = 0.0
	tween.tween_property(fade, "modulate:a", 1.0, .69)
	await tween.finished
	
	get_tree().change_scene_to_file("res://main.tscn")
