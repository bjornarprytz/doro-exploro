class_name EventBus
extends Node2D

const goal: int = 15

# Add signals here for game-wide events. Access through the Events singleton

signal game_over(win: bool)

signal planet_discovered(planet: Planet)

signal atmosphere_entered(planet: Planet)
signal atmosphere_exited(planet: Planet)
