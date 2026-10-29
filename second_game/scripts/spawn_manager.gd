class_name SecondSpawnManager
extends Node2D

signal shape_spawned(shape: FallingShape)

var shapes: Array[FallingShape] = []
var spawn_timer: float = 0.0
var random := RandomNumberGenerator.new()
var spawning: bool = false

func _ready() -> void:
	random.randomize()

func start_spawning() -> void:
	clear_shapes()
	spawn_timer = 0.0
	spawning = true

func stop_spawning() -> void:
	spawning = false

func clear_shapes() -> void:
	for shape in shapes:
		if is_instance_valid(shape): shape.queue_free()
	shapes.clear()

func _process(delta: float) -> void:
	if not spawning: return
	spawn_timer -= delta
	if spawn_timer <= 0.0:
		_spawn_shape()
		spawn_timer = 0.8
	shapes = shapes.filter(func(shape: FallingShape) -> bool: return is_instance_valid(shape) and shape.active)

func _spawn_shape() -> void:
	var shape := FallingShape.new()
	shape.position = Vector2(random.randf_range(44.0, 496.0), -50.0)
	shape.configure(random.randf() < 0.35, 64.0, random.randf_range(220.0, 320.0))
	add_child(shape)
	shapes.append(shape)
	shape_spawned.emit(shape)

