class_name Player
extends RigidBody2D

@export var max_velocity: float = 50.0
@export var accelleration: float = 600.0
@export var brake_strength: float = 250.0
@export var rotation_speed: float = 300.0 # Lowered for smoother rotation

@onready var exhaust: CPUParticles2D = %Exhaust
@onready var burn: CPUParticles2D = %Burn

var throttle: bool = false
var brake: bool = false
var turn: float = 0.0

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
		apply_central_impulse(- linear_velocity * delta)
		
	if linear_velocity.length() > max_velocity:
		apply_central_impulse(- linear_velocity.normalized() * ((linear_velocity.length() / 2) - max_velocity) / max_velocity)

	if (abs(turn) > .1):
		var rotation_dir = turn * delta * rotation_speed
		if brake:
			rotation_dir *= 1.5
		#rotation += rotation_dir
		angular_velocity = rotation_dir
	else:
		# Dampen rotation
		angular_velocity = 0
