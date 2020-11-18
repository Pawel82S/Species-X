#class_name
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
	MIN = 4000,
	MAX = 8000
}

enum MoonSeparation {
	MIN
	MAX
}

################################################################# CONSTANTS ##############################################################
const AU := 15_000	# Length of 1 AU 
const OUTER_ZONE_SIZE := AU * 20	# This is zone where Pluto is and other objects of outer solar system
const ECO_ZONE_FACTOR := 4.55
const COLD_ZONE_END_FACTOR := 81.8
const MIN_PLANET_MASS := 0	# This is minimum mass a planet can have
const MIN_MOON_MASS := 0
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
	generate()


################################################################# PUBLIC METHODS #########################################################
func generate() -> void:
	var star: Star = SCN_STAR.instance()
	celestial_bodies.add_child(star)
	star.generate()
	var mass_for_planets := star.get_max_satellites_mass()
	_calculate_zones()
	
#	while mass_for_planets > MIN_PLANET_MASS:
#		var planet := _generate_planet(mass_for_planets)
#		mass_for_planets -= planet.body_mass
#		var mass_for_moons := planet.get_max_satellites_mass()
#
#		while mass_for_moons > MIN_MOON_MASS:
#			var moon := _generate_moon(mass_for_moons)
#			mass_for_moons -= moon.body_mass


# If system has special star, then radius is equal to hot zone end
func get_radius() -> int:
	var star: Star = celestial_bodies.get_child(0)
	if star.subtype == star.SubType.NORMAL:
		return zone_range[CelestialBody.Zone.OUTER].End
	else:
		return zone_range[CelestialBody.Zone.HOT].End


################################################################# PRIVATE METHODS ########################################################
func _calculate_zones() -> void:
	var star: Star = celestial_bodies.get_child(0)
	assert(star, "System %s does not have any stars." % name)
	var star_eco_factor := ECO_ZONE_FACTOR * star.temperature
	var half_star_eco_factor := star_eco_factor / 2
	zone_range[CelestialBody.Zone.ECO].Begin = int(star_eco_factor - half_star_eco_factor + star.body_radius)
	zone_range[CelestialBody.Zone.ECO].End = int(star_eco_factor + half_star_eco_factor + star.body_radius)
	zone_range[CelestialBody.Zone.HOT].Begin = star.body_radius + 1
	zone_range[CelestialBody.Zone.HOT].End = zone_range[CelestialBody.Zone.ECO].Begin - 1
	zone_range[CelestialBody.Zone.COLD].Begin = zone_range[CelestialBody.Zone.ECO].End + 1
	zone_range[CelestialBody.Zone.COLD].End = int(COLD_ZONE_END_FACTOR * star.temperature)
	zone_range[CelestialBody.Zone.OUTER].Begin = zone_range[CelestialBody.Zone.COLD].End + 1
	zone_range[CelestialBody.Zone.OUTER].End = zone_range[CelestialBody.Zone.OUTER].Begin + OUTER_ZONE_SIZE


func _generate_planet(max_mass: int) -> CelestialBody:
	var planet: CelestialBody = SCN_BODY.instance()
	return planet


func _generate_moon(max_mass: int) -> CelestialBody:
	var moon: CelestialBody = SCN_BODY.instance()
	moon.type = CelestialBody.Type.MOON
	return moon
