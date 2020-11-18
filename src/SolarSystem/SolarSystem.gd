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
enum SatelliteSeparation {
	MIN = 750,
	MAX = 7500
}
################################################################# CONSTANTS ##############################################################
const AU := 15_000	# Length of 1 AU 
const OUTER_ZONE_SIZE := AU * 20	# This is zone where Pluto is and other objects of outer solar system
const ECO_ZONE_FACTOR := 4.55
const COLD_ZONE_END_FACTOR := 81.8
const SCN_STAR := preload("res://src/SolarSystem/Star.tscn")
const SCN_BODY := preload("res://src/SolarSystem/CelestialBody.tscn")


################################################################# EXPORT VAR #############################################################
################################################################# PUBLIC VAR #############################################################
################################################################# PRIVATE VAR ############################################################
var _hot_zone_begin := 0	# Is starting where sun surface ends
var _hot_zone_end := 0
var _eco_zone_begin := 0	# Is starting where hot zone is ending + 1
var _eco_zone_end := 0
var _cold_zone_begin := 0	# Is starting where eco zone is ending + 1
var _cold_zone_end := 0
var _outer_zone_begin := 0	# Is starting wher cold zone is ending + 1
var _outer_zone_end := 0	# Is also radius of whole system


################################################################# ONREADY VAR ############################################################
onready var celestial_bodies := $CelestialBodies


################################################################# SETTERS & GETTERS ######################################################
################################################################# BUILT-IN METHODS #######################################################
func _ready() -> void:
	generate()


################################################################# PUBLIC METHODS #########################################################
func generate() -> void:
	var star := SCN_STAR.instance()
	celestial_bodies.add_child(star)
	star.generate()
	_calculate_zones()
	var separation := Func.randi_from_range(SatelliteSeparation.MIN, SatelliteSeparation.MAX)
	var orbit_height: int = star.body_radius + separation
	var planet := SCN_BODY.instance()
	star.add_satellite(planet)
	var current_zone: int = CelestialBody.Zone.COLD
	var max_mass := 1
	planet.generate(CelestialBody.Type.PLANET, current_zone, max_mass)
	planet.orbit = orbit_height


# If system has special star, then radius is equal to hot zone end
func get_radius() -> int:
	var star: Star = celestial_bodies.get_child(0)
	if star.subtype == star.SubType.NORMAL:
		return _outer_zone_end
	else:
		return _hot_zone_end


################################################################# PRIVATE METHODS ########################################################
func _calculate_zones() -> void:
	var star: Star = celestial_bodies.get_child(0)
	assert(star, "System %s does not have any stars." % name)
	var star_eco_factor := ECO_ZONE_FACTOR * star.temperature
	var half_star_eco_factor := star_eco_factor / 2
	_eco_zone_begin = int(star_eco_factor - half_star_eco_factor + star.body_radius)
	_eco_zone_end = int(star_eco_factor + half_star_eco_factor + star.body_radius)
	_hot_zone_begin = star.body_radius + 1
	_hot_zone_end = _eco_zone_begin - 1
	_cold_zone_begin = _eco_zone_end + 1
	_cold_zone_end = int(COLD_ZONE_END_FACTOR * star.temperature)
	_outer_zone_begin = _cold_zone_end + 1
	_outer_zone_end = _outer_zone_begin + OUTER_ZONE_SIZE
