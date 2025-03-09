class_name Factory
extends Node2D

# Add factory methods for common scenes here. Access through the Create singleton

var planet_scene: PackedScene = preload("res://world/planet.tscn")
var sector_scene: PackedScene = preload("res://world/sector.tscn")
var seed_pod_scene: PackedScene = preload("res://world/seed_pod.tscn")
var flower_scene: PackedScene = preload("res://world/flower.tscn")
var inhabitant_scene: PackedScene = preload("res://world/inhabitant.tscn")

func planet(id: String) -> Planet:
	var planet_node = planet_scene.instantiate() as Planet
	planet_node.id = id
	
	if !Planet.states.has(id):
		Planet.states[id] = Planet.State.new()
	else:
		print("Planet state already exists: %s, nice" % id)
	
	planet_node.state = Planet.states[id]

	return planet_node


func sector() -> Sector:
	return sector_scene.instantiate() as Sector

func seed_pod() -> SeedPod:
	return seed_pod_scene.instantiate() as SeedPod

func flower() -> Flower:
	return flower_scene.instantiate() as Flower

func inhabitant(edges: int, color: Color) -> Inhabitant:
	var inhabitant_node = inhabitant_scene.instantiate() as Inhabitant

	inhabitant_node.edges = edges
	inhabitant_node.modulate = color

	return inhabitant_node
