class_name Planet
extends Node2D

class State:
	var size: float = randf_range(0.6, 1)
	var bubble_popped = false
	var sprite: Texture = Planet.planet_sprites.pick_random()
	var canvas_offset: Vector2 = Utility.random_vector(-100.0, 100.0)
	var flowers: Array[Vector2] = []


static var states: Dictionary[String, State] = {}

@onready var gravity_well: Area2D = %GravityWell
@onready var gravity_well_shape: CollisionShape2D = %GravityWell/Shape
@onready var planet_visual: Node2D = %Planet
@onready var planet_canvas: Sprite2D = %PlanetCanvas
@onready var planet_polygon: RegularPolygon = %Polygon

@onready var atmosphere_shape: CollisionShape2D = %Atmosphere/Shape
@onready var poulace: CPUParticles2D = %Poulace
@onready var debrids_belt: CPUParticles2D = %DebridsBelt
@onready var bubble: Sprite2D = %Bubble
@onready var pop: CPUParticles2D = %Pop
@onready var orbit: Area2D = %Orbit
@onready var orbit_shape: CollisionShape2D = $Orbit/Shape
@onready var bubble_pop: AudioStreamPlayer2D = %BubblePop
@onready var shape: CollisionPolygon2D = $Body/Shape
@onready var sky: Node2D = %Sky
@onready var glow: Node2D = %Glow

static var planet_sprites = [
	preload("res://assets/img/planets/planet-palette-01.png"),
	preload("res://assets/img/planets/planet-palette-02.png"),
	preload("res://assets/img/planets/planet-palette-03.png"),
	preload("res://assets/img/planets/planet-palette-04.png"),
	preload("res://assets/img/planets/planet-palette-05.png"),
	preload("res://assets/img/planets/planet-palette-06.png"),
	preload("res://assets/img/planets/planet-palette-07.png"),
	preload("res://assets/img/planets/planet-palette-08.png"),
]

var id: String

var state: State:
	get:
		if !Planet.states.has(id):
			push_error("Planet state not found: " + id)

		return Planet.states[id]


var perimiter: float:
	get:
		return orbit_shape.shape.radius * state.size

func _ready() -> void:
	gravity_well.gravity_point_unit_distance = atmosphere_shape.shape.radius * state.size

	update_visuals_based_on_state()

func update_visuals_based_on_state():
	planet_canvas.texture = state.sprite
	planet_canvas.offset = state.canvas_offset

	scale = Vector2(state.size, state.size)

	if !state.bubble_popped:
		bubble.show()
	else:
		bubble.hide()
		if !Symphony.beat.is_connected(_on_beat):
			Symphony.beat.connect(_on_beat)

	for flower_direction in state.flowers:
		_add_flower_internal(flower_direction)

func pop_bubble():
	if state.bubble_popped:
		return
	bubble_pop.play(0.32)
	state.bubble_popped = true
	bubble.hide()
	pop.emitting = true

const transition_time := .39

var transition_tween: Tween

func add_flower(g_position: Vector2) -> void:
	var direction = (g_position - global_position).normalized()
	_add_flower_internal(direction)
	state.flowers.push_back(direction)

func _add_flower_internal(direction: Vector2):
	if (!direction.is_normalized()):
		push_error("flower direction should be normalized!")
		return
	
	var flower = Create.flower()
	planet_visual.add_child(flower)

	# Position at the surface of the planet
	flower.position = direction * (planet_polygon.size)
	flower.rotation = direction.angle()
	

func transition_into_focus():
	if transition_tween:
		transition_tween.stop()

	transition_tween = create_tween().set_parallel()
	sky.show()
	sky.scale = Vector2.ZERO
	sky.modulate.a = 0.0
	transition_tween.tween_property(sky, "scale", Vector2.ONE, transition_time)
	transition_tween.tween_property(sky, "modulate:a", 1.0, transition_time)
	transition_tween.tween_property(glow, "scale", Vector2.ZERO, transition_time)
	if Symphony.beat.is_connected(_on_beat):
		Symphony.beat.disconnect(_on_beat)

func transition_out_of_focus():
	if transition_tween:
		transition_tween.stop()

	transition_tween = create_tween().set_parallel()
	transition_tween.tween_property(sky, "modulate:a", 0.0, transition_time)
	transition_tween.tween_property(sky, "scale", Vector2.ZERO, transition_time)
	transition_tween.tween_property(glow, "scale", Vector2.ONE, transition_time)
	transition_tween.set_parallel(false)
	transition_tween.tween_callback(sky.hide)
	
	if state.bubble_popped and !Symphony.beat.is_connected(_on_beat):
		Symphony.beat.connect(_on_beat)

func _on_beat(_number: int):
	var tween = create_tween()
	poulace.emitting = true
	tween.tween_property(planet_visual, "scale", Vector2.ONE * 1.1, .069)
	tween.set_parallel()
	tween.tween_property(shape, "scale", Vector2.ONE * 1.1, .069)
	tween.set_parallel(false)
	tween.tween_property(planet_visual, "scale", Vector2.ONE, .169)
	tween.set_parallel()
	tween.tween_property(shape, "scale", Vector2.ONE, .169)

func _on_atmosphere_body_entered(body: Node2D) -> void:
	if (body is Player):
		Events.atmosphere_entered.emit(self)

func _on_atmosphere_body_exited(body: Node2D) -> void:
	if (body is Player):
		Events.atmosphere_exited.emit(self)
