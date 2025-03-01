class_name SeedPod
extends RigidBody2D


func _on_body_entered(body: Node) -> void:
	if body.owner is Planet:
		queue_free()
		var flower = Create.flower()
		var planet = body.owner as Planet
		planet.add_flower(flower, global_position)
