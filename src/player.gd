class_name Player
extends RigidBody2D

@export var max_velocity: float = 50.0
@export var max_velocity_in_atmostphere: float = 10.0
@export var accelleration: float = 600.0
@export var accelleration_in_atmostphere: float = 200.0

@export var brake_strength: float = 250.0
@export var rotation_speed: float = 300.0 # Lowered for smoother rotation

@onready var exhaust: CPUParticles2D = %Exhaust
@onready var burn: CPUParticles2D = %Burn

@onready var _max_velocity: float = max_velocity
@onready var _accelleration: float = accelleration

var throttle: bool = false
var brake: bool = false
var turn: float = 0.0

var current_planet: Planet = null

func _ready() -> void:
	Events.atmosphere_entered.connect(_on_atmosphere_entered)
	Events.atmosphere_exited.connect(_on_atmosphere_exited)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("throttle"):
		throttle = true
		exhaust.emitting = true
	elif event.is_action_released("throttle"):
		throttle = false
		exhaust.emitting = false
	if event.is_action_pressed("brake"):
		brake = true
		burn.emitting = true
	elif event.is_action_released("brake"):
		brake = false
		burn.emitting = false
	
	if event.is_action_pressed("seed") and current_planet:
		_fire_seed(current_planet)

	# Get rotation input (supports both keyboard and joystick)
	turn = Input.get_axis("ui_left", "ui_right")

func _fire_seed(planet: Planet) -> void:
	var seed_pod = Create.seed_pod()

	planet.add_child(seed_pod)
	seed_pod.global_position = global_position
	var direction = (planet.global_position - seed_pod.global_position).normalized()
	seed_pod.apply_central_impulse(direction * 100)

func _physics_process(delta: float) -> void:
	if throttle:
		apply_central_impulse(Vector2.UP.rotated(rotation) * _accelleration * delta)
	if brake:
		# Damp
		apply_central_impulse(- linear_velocity * delta)
		
	if linear_velocity.length() > max_velocity:
		apply_central_impulse(- linear_velocity.normalized() * ((linear_velocity.length() / 2) - _max_velocity) / _max_velocity)

	if (abs(turn) > .1):
		var rotation_dir = turn * delta * rotation_speed
		if brake:
			rotation_dir *= 1.5
		angular_velocity = rotation_dir
	else:
		# Dampen rotation
		angular_velocity = 0

func _on_atmosphere_entered(planet: Planet) -> void:
	current_planet = planet
	_max_velocity = max_velocity_in_atmostphere
	_accelleration = accelleration_in_atmostphere

func _on_atmosphere_exited(_planet: Planet) -> void:
	current_planet = null
	_max_velocity = max_velocity
	_accelleration = accelleration
