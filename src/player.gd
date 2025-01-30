class_name Player
extends RigidBody2D

signal atmosphere_entered(planet: Planet)
signal atmosphere_exited

signal orbit_entered(planet: Planet)
signal orbit_exited

@export var max_velocity: float = 50.0
@export var accelleration: float = 600.0
@export var brake_strength: float = 250.0
@export var rotation_speed: float = 3.0 # Lowered for smoother rotation
@export var strafe_speed = 450.0

@onready var exhaust: CPUParticles2D = %Exhaust
@onready var burn: CPUParticles2D = %Burn

var throttle: bool = false
var brake: bool = false
var turn: float = 0.0
var force_show_hud = false

var nearby_planets: Array[Planet] = []
var host_planet = null

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

	# Get rotation input (supports both keyboard and joystick)
	turn = Input.get_axis("ui_left", "ui_right")

func _physics_process(delta: float) -> void:

	if throttle:
		apply_central_impulse(Vector2.UP.rotated(rotation) * accelleration * delta)
	if brake:
		# Damp
		apply_central_impulse(-linear_velocity * delta)
		
	if linear_velocity.length() > max_velocity:
		apply_central_impulse(-linear_velocity.normalized() * ((linear_velocity.length() / 2) - max_velocity) / max_velocity)
	
	if (abs(turn) > .1):
		var rotation_dir = turn * delta * rotation_speed
		if brake:
			rotation_dir *= 1.5
		rotation += rotation_dir

func entered_orbit(planet: Planet) -> void:
	host_planet = planet
	orbit_entered.emit(host_planet)

func exited_orbit() -> void:
	host_planet = null
	orbit_exited.emit()
