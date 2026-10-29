class_name Arena
extends Node2D

signal target_removed(target: Target)
var targets: Array[Target] = []
var arena_size: Vector2 = Vector2(1080, 1920)
var shake_time: float = 0.0

func clear_targets() -> void:
	for target in targets:
		if is_instance_valid(target): target.queue_free()
	targets.clear()

func add_target(target: Target) -> void:
	targets.append(target)
	add_child(target)

func remove_target(target: Target) -> void:
	if target in targets: targets.erase(target)
	if is_instance_valid(target): target.queue_free()
	target_removed.emit(target)

func _process(delta: float) -> void:
	var safe_delta: float = minf(delta, 0.05)
	shake_time = maxf(0.0, shake_time - safe_delta)
	position = Vector2(sin(shake_time * 90.0), cos(shake_time * 73.0)) * 7.0 if shake_time > 0.0 else Vector2.ZERO
	for target in targets:
		if not is_instance_valid(target): continue
		if target.velocity.length_squared() > 0.0:
			target.position += target.velocity * safe_delta
			var min_x: float = target.radius
			var max_x: float = arena_size.x - target.radius
			var min_y: float = arena_size.y * 0.12 + target.radius
			var max_y: float = arena_size.y * 0.92 - target.radius
			if target.position.x < min_x or target.position.x > max_x:
				target.velocity.x *= -1.0; target.position.x = clampf(target.position.x, min_x, max_x)
			if target.position.y < min_y or target.position.y > max_y:
				target.velocity.y *= -1.0; target.position.y = clampf(target.position.y, min_y, max_y)

func shake() -> void:
	shake_time = 0.12

