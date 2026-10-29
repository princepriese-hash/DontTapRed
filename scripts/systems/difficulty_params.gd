class_name DifficultyParams
extends RefCounted

var object_count: int
var red_count: int
var radius: float
var speed: float
var window: float

func _init(count: int, reds: int, target_radius: float, movement_speed: float, wave_window: float) -> void:
	object_count = count
	red_count = reds
	radius = target_radius
	speed = movement_speed
	window = wave_window

