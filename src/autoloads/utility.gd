extends Node

func shake(node: CanvasItem, duration: float, magnitude: float) -> Tween:
	var tween = node.create_tween()
	const shake_duration: float = 0.01
	
	var n_shakes: int = int(duration / shake_duration)
	
	for i in range(n_shakes):
		tween.tween_property(node, "position", node.position + Vector2(randf_range(-magnitude, magnitude), randf_range(-magnitude, magnitude)), shake_duration)
		tween.tween_property(node, "position", node.position, shake_duration)
	
	return tween

func jelly_scale(node: CanvasItem, duration: float) -> Tween:
	var tween = node.create_tween()
	var target_scale = node.scale
	node.scale = Vector2.ZERO
	tween.tween_property(node, "scale", target_scale, duration).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
	return tween

func jiggle(node: CanvasItem, magnitude: float, n_jiggles: int = 1, original_scale: Vector2 = Vector2.ONE) -> Tween:
	var tween = node.create_tween()

	var upper_scale = node.scale + Vector2.ONE * magnitude
	var lower_scale = node.scale - Vector2.ONE * magnitude

	for n in range(n_jiggles):
		tween.tween_property(node, "scale", upper_scale, 0.05)
		tween.tween_property(node, "scale", lower_scale, 0.05)
	
	tween.tween_property(node, "scale", original_scale, 0.05)
	
	return tween

# Function to calculate relative luminance of an RGB color
func get_luminance(color: Color) -> float:
	return 0.2126 * color.r + 0.7152 * color.g + 0.0722 * color.b

# Function to get contrast color (either black or white) based on luminance
func get_contrast_color(color: Color) -> Color:
	var luminance = get_luminance(color)
	
	# If luminance is higher than 0.5, return black, otherwise return white
	if luminance > 0.5:
		return Color(0, 0, 0) # Black
	else:
		return Color(1, 1, 1) # White

func random_color() -> Color:
	return Color(
		randf_range(0, 1),
		randf_range(0, 1),
		randf_range(0, 1)
	)

func random_vector(min: float = -1, max: float = 1) -> Vector2:
	return Vector2(
		randf_range(min, max),
		randf_range(min, max)
	)

func fade_in(node: CanvasItem, duration: float) -> Tween:
	var tween = node.create_tween()
	node.modulate.a = 0
	tween.tween_property(node, "modulate:a", 1.0, duration)

	return tween

func to_dictionary(o: Variant) -> Dictionary:
	var dict = {}
	
	if o == null:
		return dict
	
	# Get a list of all properties on the object
	var property_list = o.get_property_list()
	
	for prop in property_list:
		var prop_name = prop.name
		match prop_name:
			"script":
				continue
			"RefCounted":
				continue
			"Built-in script":
				continue
			_:
				pass
		
		match prop.type:
			TYPE_OBJECT:
				dict[prop_name] = to_dictionary(o.get(prop_name))
			TYPE_NIL:
				dict[prop_name] = null
			_:
				dict[prop_name] = o.get(prop_name)
				
	
	return dict
