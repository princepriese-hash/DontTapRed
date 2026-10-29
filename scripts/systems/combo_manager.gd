class_name ComboManager
extends RefCounted

var streak: int = 0
var best_streak: int = 0

func register_safe_tap() -> void:
	streak += 1
	best_streak = maxi(best_streak, streak)

func register_mistake() -> void:
	streak = streak / 2

func reset() -> void:
	streak = 0
	best_streak = 0

func multiplier() -> float:
	if streak >= 35: return 3.0
	if streak >= 20: return 2.5
	if streak >= 10: return 2.0
	if streak >= 5: return 1.5
	return 1.0

