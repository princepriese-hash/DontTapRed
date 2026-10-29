class_name ScoreManager
extends RefCounted

var base_points: float = 10.0
var speed_bonus: float = 0.5
var diff_step: float = 0.015
var risk_multiplier: float = 1.2

func _init() -> void:
	var file := FileAccess.open("res://data/balance.json", FileAccess.READ)
	if file:
		var data: Dictionary = JSON.parse_string(file.get_as_text())
		var config: Dictionary = data.get("scoring", {})
		base_points = float(config.get("base", base_points))
		speed_bonus = float(config.get("speed_bonus", speed_bonus))
		diff_step = float(config.get("diff_step", diff_step))
		risk_multiplier = float(config.get("risk_multiplier", risk_multiplier))

func points(reaction: float, window: float, streak: int, level: int, risky: bool) -> int:
	var speed_factor: float = 1.0 + speed_bonus * clampf(1.0 - reaction / maxf(window, 0.001), 0.0, 1.0)
	var combo_mult: float = 3.0 if streak >= 35 else (2.5 if streak >= 20 else (2.0 if streak >= 10 else (1.5 if streak >= 5 else 1.0)))
	var diff_mult: float = 1.0 + diff_step * mini(level, 100)
	var risk_factor: float = risk_multiplier if risky else 1.0
	return roundi(base_points * speed_factor * combo_mult * diff_mult * risk_factor)

func wave_bonus(level: int, mistake: bool) -> int:
	return roundi(20.0 * level * (1.0 if mistake else 1.5))

