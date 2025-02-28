class_name InfiniteSectors
extends Node2D

@export var sector_size: Vector2i = Vector2i(2000, 2000)

# Check which sectors are in view and load their neighbors
@export var camera: Camera2D
@export var cache_size: Vector2i = Vector2i(4, 4)

var sectors: Array[Sector] = []

var current_sector: Sector

func _ready() -> void:
	# Load the sectors
	for i in range(0, cache_size.x):
		for j in range(0, cache_size.y):
			var sector = Create.sector()
			sector.size = sector_size
			sector.position = Vector2(i * sector_size.x, j * sector_size.y)
			sector.name = "Sector(%d, %d)" % [i, j]
			sectors.append(sector)
			add_child(sector)
			sector.set_coords_and_regenerate_planets(Vector2i(i, j))
			sector.player_entered.connect(_on_player_entered)

func _on_player_entered(sector: Sector, _player: Player):
	current_sector = sector
	_scroll_sectors()

func _scroll_sectors() -> void:
	var current_coords = current_sector.coordinates
	
	for sector in sectors:
		var sector_coords = sector.coordinates
		var delta = sector_coords - current_coords

		# Wrap horizontally
		if delta.x < -1:
			sector_coords.x += cache_size.x
		elif delta.x > cache_size.x - 2:
			sector_coords.x -= cache_size.x

		# Wrap vertically
		if delta.y < -1:
			sector_coords.y += cache_size.y
		elif delta.y > cache_size.y - 2:
			sector_coords.y -= cache_size.y

		# Only reposition if needed
		if sector_coords != sector.coordinates:
			sector.set_coords_and_regenerate_planets.call_deferred(sector_coords)
			sector.position = Vector2(sector_coords.x * sector_size.x, sector_coords.y * sector_size.y)
