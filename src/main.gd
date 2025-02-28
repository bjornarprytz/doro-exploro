extends Node2D
@onready var player: Player = %Player
@onready var camera: Camera2D = %Camera
@onready var goal: RichTextLabel = %Goal
@onready var fade_out: ColorRect = %FadeOut

func _ready() -> void:
	Events.discovered = []
	Events.game_over.connect(_on_game_over)
	Events.atmosphere_entered.connect(_on_atmosphere_entered)
	
func _process(_delta: float) -> void:
	camera.position = player.position

func _on_game_over(_win: bool):
	var tween = create_tween()
	fade_out.show()
	fade_out.modulate.a = 0.0
	tween.tween_property(fade_out, "modulate:a", 1.0, 7.69)
	await tween.finished
	get_tree().change_scene_to_file("res://credits.tscn")

func _on_atmosphere_entered(planet: Planet):
	if planet.type in Events.discovered:
		return

	Events.discovered.push_back(planet.type)
	Symphony.add_instrument()
	_update_goal()
	Events.planet_discovered.emit(planet)

	if (Events.discovered.size() >= Events.goal):
		Events.game_over.emit(true)

func _update_goal():
	goal.text = "%s / %s" % [Events.discovered.size(), Events.goal]
