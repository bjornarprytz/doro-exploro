class_name Inhabitant
extends RigidBody2D

@onready var shape: CollisionPolygon2D = %Shape
@onready var polygon: RegularPolygon = %Polygon


var edges: int = 3:
	set(new_edges):
		if (edges == new_edges):
			return
		edges = new_edges
		
		if is_node_ready():
			polygon.n_sides = edges
			shape.polygon = polygon.polygon

func _ready() -> void:
	polygon.n_sides = edges
	shape.polygon = polygon.polygon
