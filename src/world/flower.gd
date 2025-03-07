class_name Flower
extends Node2D

@onready var pollen: CPUParticles2D = %Pollen
@onready var animation: AnimatedSprite2D = $Animation

func _ready() -> void:
	animation.animation_finished.connect(Symphony.beat.connect.bind(_on_beat))
	
	pollen.modulate = Utility.random_color()

func _on_beat(_number: int):
	pollen.emitting = true
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * 1.1, .069)
	tween.tween_property(self, "scale", Vector2.ONE, .169)
