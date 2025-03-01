class_name Factory
extends Node2D

# Add factory methods for common scenes here. Access through the Create singleton

var planet_scene: PackedScene = preload("res://world/planet.tscn")
var sector_scene: PackedScene = preload("res://world/sector.tscn")
var seed_pod_scene: PackedScene = preload("res://world/seed_pod.tscn")
var flower_scene: PackedScene = preload("res://world/flower.tscn")

func planet() -> Planet:
	return planet_scene.instantiate() as Planet

func sector() -> Sector:
	return sector_scene.instantiate() as Sector

func seed_pod() -> SeedPod:
	return seed_pod_scene.instantiate() as SeedPod

func flower() -> Flower:
	return flower_scene.instantiate() as Flower
