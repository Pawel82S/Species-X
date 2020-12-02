class_name SolarSystem
extends Node2D
"""
Each system is divided on 4 zones around a star. This zones are used to determine which planet classes can be placed in particular zones.
The zones are as follows:
	1) Hot Zone - is starting just above the surface of the star and its range is dependent on star temperature. This is the zone where
		planets like Mercury and Venus are.
	2) Eco Zone - is starting where Hot is ending and its range is dependent on star temperature. This is the zone where planets like
		Earth and Mars are.
	3) Cold Zone - is starting where Eco Zone is ending and its range is dependant on star temperature. This is the zone where planets like
		Jupiter, Saturn, Neptun are.
	4) Outer Zone - is starting where Cold Zone is ending and its going up to MAX_SYSTEM_RADIUS constant.

Earth is 1 AU from the Sun which is avarge distance of 150Mkm. This distance is represented by AU constant in pixels.
"""
################################################################# SIGNALS ################################################################
################################################################# ENUMS ##################################################################
enum PlanetSeparation {
	MIN = 4_000,
	MAX = 10_000
}

enum MoonSeparation {
	MIN = 600,
	MAX = 950
}

################################################################# CONSTANTS ##############################################################
const AU := 15_000	# Length of 1 AU 
const OUTER_ZONE_SIZE := AU * 20	# This is zone where Pluto is and other objects of outer solar system
const ECO_ZONE_FACTOR := 4.55
const COLD_ZONE_END_FACTOR := 81.8
const INVALID_ZONE := -1
const SCN_STAR := preload("res://src/SolarSystem/Star.tscn")
const SCN_BODY := preload("res://src/SolarSystem/CelestialBody.tscn")

################################################################# EXPORT VAR #############################################################
################################################################# PUBLIC VAR #############################################################
################################################################# PRIVATE VAR ############################################################
var zone_range = {
		CelestialBody.Zone.HOT: {
				"Begin": 0,
				"End": 0
			},
		CelestialBody.Zone.ECO: {
				"Begin": 0,
				"End": 0
			},
		CelestialBody.Zone.COLD: {
				"Begin": 0,
				"End": 0
			},
		CelestialBody.Zone.OUTER: {
				"Begin": 0,
				"End": 0
			}
	}

################################################################# ONREADY VAR ############################################################
onready var celestial_bodies := $CelestialBodies


################################################################# SETTERS & GETTERS ######################################################
################################################################# BUILT-IN METHODS #######################################################
func _ready() -> void:
	Func.ignore_result(Event.connect("object_selected", self, "_on_object_selected"))


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("galaxy_map"):
		visible = false


################################################################# PUBLIC METHODS #########################################################
func generate(system_name: String) -> void:
	var star := _generate_star(system_name)
	var mass_for_planets := star.get_max_satellites_mass()
	_calculate_zones()
	var orbit: int = zone_range[CelestialBody.Zone.HOT].Begin

	while mass_for_planets > CelestialBody.PlanetMass.MIN && orbit < get_radius() - PlanetSeparation.MAX:
		orbit += Func.randi_from_range(PlanetSeparation.MIN, PlanetSeparation.MAX)
		var zone := _get_zone_form_orbit(orbit)
		if zone > INVALID_ZONE:
			var planet := _generate_satellite(star, CelestialBody.ObjectType.PLANET, zone, mass_for_planets)
			mass_for_planets -= planet.object_mass
			planet.object_orbit = orbit
			
			var mass_for_moons := planet.get_max_satellites_mass()
			var moon_orbit := planet.object_radius
			# TODO: Limit adding moons so planet orbit wont leave zone
			while mass_for_moons > CelestialBody.MoonMass.MIN:
				moon_orbit += Func.randi_from_range(MoonSeparation.MIN, MoonSeparation.MAX)
				var moon := _generate_satellite(planet, CelestialBody.ObjectType.MOON, zone, mass_for_moons)
				mass_for_moons -= moon.object_mass
				moon.object_orbit = moon_orbit
				orbit += moon_orbit
			
			# Check if we added some moons and move planet orbit if it's true to avoid moons on orbits crossing onther planets or star
			if moon_orbit != planet.object_radius:
				planet.object_orbit += moon_orbit
		else:
			break
	
	print("%s system has %d planets and %d moons" % [name, get_planets_count(), get_moons_count()])


# If system has special star, then radius is equal to hot zone end
func get_radius() -> int:
	var star: Star = get_star()
	if star.star_type == Star.StarType.NORMAL:
		return zone_range[CelestialBody.Zone.OUTER].End
	else:
		return zone_range[CelestialBody.Zone.HOT].End


func get_planets_count() -> int:
	var star: Star = get_star()
	return star.get_satellites_count()


func get_moons_count() -> int:
	var star: Star = get_star()
	var result := 0
	for planet in star.get_satellites():
		result += planet.get_satellites_count()
	return result


func get_star() -> Star:
	return celestial_bodies.get_child(0) as Star


func get_icon_texture() -> Texture:
	return get_star().icon


func get_object_position(object_name: String) -> Vector2:
	var star := get_star()
	var result: Vector2 = star.body.global_position
	if star.object_name != object_name:
		for planet in star.get_satellites():
			if planet.object_name == object_name:
				result = planet.body.global_position
				break
			
			for moon in planet.get_satellites():
				if moon.object_name == object_name:
					result = moon.body.global_position
					return result
	
	return result


################################################################# PRIVATE METHODS ########################################################
func _generate_star(star_name: String) -> Star:
	var result: Star = SCN_STAR.instance()
	celestial_bodies.add_child(result)
	name = star_name
	result.object_name = name
	result.generate()
	return result


func _calculate_zones() -> void:
	var star: Star = get_star()
	assert(star, "System %s does not have any stars." % name)
	var star_eco_factor := ECO_ZONE_FACTOR * star.object_temperature
	var half_star_eco_factor := star_eco_factor / 2
	zone_range[CelestialBody.Zone.ECO].Begin = int(star_eco_factor - half_star_eco_factor + star.object_radius)
	zone_range[CelestialBody.Zone.ECO].End = int(star_eco_factor + half_star_eco_factor + star.object_radius)
	zone_range[CelestialBody.Zone.HOT].Begin = star.object_radius + 1
	zone_range[CelestialBody.Zone.HOT].End = zone_range[CelestialBody.Zone.ECO].Begin - 1
	zone_range[CelestialBody.Zone.COLD].Begin = zone_range[CelestialBody.Zone.ECO].End + 1
	zone_range[CelestialBody.Zone.COLD].End = int(COLD_ZONE_END_FACTOR * star.object_temperature)
	zone_range[CelestialBody.Zone.OUTER].Begin = zone_range[CelestialBody.Zone.COLD].End + 1
	zone_range[CelestialBody.Zone.OUTER].End = zone_range[CelestialBody.Zone.OUTER].Begin + OUTER_ZONE_SIZE


func _get_zone_form_orbit(orbit: int) -> int:
	var result := INVALID_ZONE
	
	for zone in zone_range:
		if orbit < zone_range[zone].End:
			result = zone
			break
	
	return result


func _generate_satellite(parent: SystemObject, type: int, zone: int, max_mass: int) -> CelestialBody:
	assert(type == SystemObject.ObjectType.PLANET || type == SystemObject.ObjectType.MOON)
	var result: CelestialBody = SCN_BODY.instance()
	parent.add_satellite(result)
	result.object_name = "%s-%d" % [parent.object_name, parent.get_satellites_count()]
	result.rotation_degrees = randi() % 360
	result.body.rotation_degrees = -result.rotation_degrees
	result.generate(type, zone, max_mass)	
	return result


func _on_SolarSystem_visibility_changed() -> void:
	var param := self if visible else null
	Event.emit_signal("system_changed", param)
	_toggle_physics(!visible)


func _toggle_physics(disable: bool) -> void:
	var star := get_star()
	star.toggle_physics(disable)
	
	for planet in star.get_satellites():
		planet.toggle_physics(disable)
		for moon in planet.get_satellites():
			moon.toggle_physics(disable)
