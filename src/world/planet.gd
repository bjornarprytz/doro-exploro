class_name Planet
extends Node2D

@onready var gravity_well: Area2D = %GravityWell
@onready var gravity_well_shape: CollisionShape2D = %GravityWell/Shape
@onready var planet_sprite: Sprite2D = %Planet
@onready var atmosphere_shape: CollisionShape2D = %Atmosphere/Shape
@onready var poulace: CPUParticles2D = %Poulace
@onready var debrids_belt: CPUParticles2D = %DebridsBelt
@onready var bubble: Sprite2D = %Bubble
@onready var pop: CPUParticles2D = %Pop
@onready var orbit: Area2D = %Orbit
@onready var orbit_shape: CollisionShape2D = $Orbit/Shape
@onready var bubble_pop: AudioStreamPlayer2D = %BubblePop
@onready var shape: CollisionPolygon2D = $Body/Shape
@onready var sky: Sprite2D = %Sky

var planet_sprites = [
preload("res://assets/img/planets/beige, brown greenish asteroid.png"),
preload("res://assets/img/planets/blue and blue rings.png"),
preload("res://assets/img/planets/blue moon.png"),
preload("res://assets/img/planets/blue red astroid.png"),
preload("res://assets/img/planets/blue white astroid.png"),
preload("res://assets/img/planets/Blueplanet orange belt.png"),
preload("res://assets/img/planets/Brown RAMS.png"),
preload("res://assets/img/planets/colores rings.png"),
preload("res://assets/img/planets/cyan purple astroid.png"),
preload("res://assets/img/planets/green rings.png"),
preload("res://assets/img/planets/greengray moon.png"),
preload("res://assets/img/planets/MARS 3.png"),
preload("res://assets/img/planets/OG asteroud.png"),
preload("res://assets/img/planets/OG moon.png"),
preload("res://assets/img/planets/pink purple moon.png"),
preload("res://assets/img/planets/pixil-frame-0 (9).png"),
preload("res://assets/img/planets/pixil-frame-0 (16).png"),
preload("res://assets/img/planets/PURPLE ARRET.png"),
preload("res://assets/img/planets/Purple RAMS.png"),
preload("res://assets/img/planets/purple rings .png"),
preload("res://assets/img/planets/RAMS BLUE CYAN PURPLE.png"),
preload("res://assets/img/planets/RAMS GREEN RED.png"),
preload("res://assets/img/planets/RAMS Purple.png"),
preload("res://assets/img/planets/RED RAMS.png"),
preload("res://assets/img/planets/SATURN.png"),
preload("res://assets/img/planets/TERRA.png"),
preload("res://assets/img/planets/WEIRD ARRET.png"),
preload("res://assets/img/planets/weird colors astroid.png"),
preload("res://assets/img/planets/weird.png"),
]

var size: float = 1.0
var bubble_popped = false
var type: String
var id: float = 0

var radius: float:
	get:
		return orbit_shape.shape.radius * size

func _ready() -> void:
	var texture = planet_sprites.pick_random()
	planet_sprite.texture = texture
	type = texture.get_path().get_file().get_basename()
	id = randf_range(0, 1)
	
	Events.planet_discovered.connect(_on_planet_discovered)
	
	if (type in Events.discovered):
		_pop_bubble(true)

func _on_planet_discovered(planet: Planet):
	if planet == self:
		return
	
	if (planet.type == type):
		_pop_bubble()

func set_size(s: float):
	size = s
	scale = Vector2(s, s)
	gravity_well.gravity_point_unit_distance = atmosphere_shape.shape.radius * size

func _pop_bubble(silent: bool = false):
	if bubble_popped:
		return
	if (!silent):
		bubble_pop.play(0.32)
	bubble_popped = true
	Symphony.beat.connect(_on_beat)
	bubble.hide()
	pop.emitting = true

func _on_beat(_number: int):
	var tween = create_tween()
	poulace.emitting = true
	tween.tween_property(planet_sprite, "scale", Vector2.ONE * 1.1, .069)
	tween.set_parallel()
	tween.tween_property(shape, "scale", Vector2.ONE * 1.1, .069)
	tween.set_parallel(false)
	tween.tween_property(planet_sprite, "scale", Vector2.ONE, .169)
	tween.set_parallel()
	tween.tween_property(shape, "scale", Vector2.ONE, .169)

func _on_atmosphere_body_entered(body: Node2D) -> void:
	if (body is Player):
		_pop_bubble()
		Events.atmosphere_entered.emit(self)

func _on_atmosphere_body_exited(body: Node2D) -> void:
	if (body is Player):
		Events.atmosphere_exited.emit(self)
