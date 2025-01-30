class_name Factory
extends Node2D

# Add factory methods for common scenes here. Access through the Create singleton

var planet_scene: PackedScene = preload("res://world/planet.tscn")
var sector_scene: PackedScene = preload("res://world/sector.tscn")

func planet() -> Planet:
	return planet_scene.instantiate() as Planet

func sector() -> Sector:
	return sector_scene.instantiate() as Sector
