extends Node2D
@onready var player: Player = %Player
@onready var camera: Camera2D = %Camera
@onready var goal: RichTextLabel = %Goal
@onready var fade_out: ColorRect = %FadeOut

@onready var current_planet: Node2D = null

func _ready() -> void:
	Events.discovered = []
	Events.game_over.connect(_on_game_over)
	Events.atmosphere_entered.connect(_on_atmosphere_entered)
	Events.atmosphere_exited.connect(_on_atmosphere_exited)

	camera.global_position = player.global_position

	
func _process(_delta: float) -> void:
	if current_planet:
		# Midway point between player and planet
		camera.position = lerp(camera.global_position, (player.global_position + current_planet.global_position) / 2, 0.069)
	else:
		camera.position = lerp(camera.global_position, player.global_position, 0.069)

func _on_game_over(_win: bool):
	var tween = create_tween()
	fade_out.show()
	fade_out.modulate.a = 0.0
	tween.tween_property(fade_out, "modulate:a", 1.0, 7.69)
	await tween.finished
	get_tree().change_scene_to_file("res://credits.tscn")

func _on_atmosphere_entered(planet: Planet):
	_transition_to_planet_scene(planet)
	
	if planet.type in Events.discovered:
		return

	planet.pop_bubble()
	
	Events.discovered.push_back(planet.type)
	Symphony.add_instrument()
	_update_goal()
	Events.planet_discovered.emit(planet)


	if (Events.discovered.size() >= Events.goal):
		Events.game_over.emit(true)
	
func _on_atmosphere_exited(planet: Planet):
	_transition_out_of_planet_scene(planet)

func _transition_out_of_planet_scene(planet: Planet) -> void:
	current_planet = null
	var tween = create_tween()
	tween.tween_property(camera, "zoom", Vector2.ONE, 1.0)
	planet.transition_out_of_focus()

func _transition_to_planet_scene(planet: Planet) -> void:
	current_planet = planet
	var tween = create_tween()
	tween.tween_property(camera, "zoom", Vector2.ONE * 1.3, 1.0)
	planet.transition_into_focus()

func _update_goal():
	goal.text = "%s / %s" % [Events.discovered.size(), Events.goal]
