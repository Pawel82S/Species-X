extends Node


static func randi_from_range(from: float, to: float) -> int:
	assert(to > from)
	return int(randi() % int(to - from + 1) + from)


static func randf_from_range(from: float, to: float) -> float:
	assert(to > from)
	return rand_range(from, to)


static func celsius_from_kelvin(temp: float) -> float:
	return temp - 273.15


static func celsius_from_farenheit(temp: float) -> float:
	return (temp - 32) * 5 / 9


static func farenheit_from_kelvin(temp: float) -> float:
	return temp * 9 / 5 - 459.67


static func farenheit_from_celsius(temp: float) -> float:
	return temp * 9 / 5 + 32


static func kelvin_from_celsius(temp: float) -> float:
	return temp + 273.15


static func kelvin_from_farenheit(temp: float) -> float:
	return (temp + 459.67) * 5 / 9


static func ignore_result(_r) -> void:
	pass
