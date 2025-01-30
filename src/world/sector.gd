class_name Sector
extends Node2D

@export var size = Vector2(2000, 2000)
@export var planet_count = 2
@export var min_distance = 100 # Minimum distance between planets

var planets: Array[Planet] = []

signal entered_screen()
signal exited_screen()

signal player_entered(sector: Sector, player: Player)

var coordinates: Vector2 = Vector2()

func set_coords_and_regenerate_planets(coords: Vector2i) -> void:
	self.coordinates = coords

	# Seed the random number generator
	seed(hash(coords))

	# Remove all existing planets
	for planet in planets:
		if (planet != null and !planet.is_queued_for_deletion()):
			planet.queue_free()
	planets.clear()

	# Generate new planets
	for i in range(planet_count):
		var planet = Create.planet()
		
		planets.append(planet)
		add_child(planet)
		
		planet.set_size(randf_range(0.6, 1))
		set_valid_position_or_destroy(planet, min_distance)

func set_valid_position_or_destroy(planet: Planet, min_dist: float) -> void:

	var planetSafePerimiter = planet.radius + min_dist

	var max_attempts = 50 # Prevent infinite loops
	for _i in range(max_attempts):
		var pos = Vector2(randf_range(planetSafePerimiter, size.x - planetSafePerimiter), randf_range(planetSafePerimiter, size.y - planetSafePerimiter))
		# Check distance to all existing planets
		var valid = true
		for other in planets:
			if pos.distance_to(other.position) < (planetSafePerimiter + other.radius):
				valid = false
				break
		if valid:
			planet.position = pos
			return
	# If we fail to find a valid spot after max_attempts, destroy the planet
	planet.queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	entered_screen.emit()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	exited_screen.emit()


func _on_player_detection_body_entered(body: Node2D) -> void:
	if (body is Player):
		player_entered.emit(self, body)
