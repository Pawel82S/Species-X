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
	MIN = 4_000,
	MAX = 10_000
}

enum MoonSeparation {
	MIN = 2_000,
	MAX = 5_000
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
	generate()


################################################################# PUBLIC METHODS #########################################################
func generate() -> void:
	var star: Star = SCN_STAR.instance()
	celestial_bodies.add_child(star)
	star.generate()
	var mass_for_planets := star.get_max_satellites_mass()
	_calculate_zones()
	
	var orbit: int = zone_range[CelestialBody.Zone.HOT].Begin
	while mass_for_planets > CelestialBody.PlanetMass.MIN:
		orbit += Func.randi_from_range(PlanetSeparation.MIN, PlanetSeparation.MAX)
		var zone := _get_zone_form_orbit(orbit)
		if zone > INVALID_ZONE:
			var planet: CelestialBody = SCN_BODY.instance()
			star.add_satellite(planet)
			planet.rotation_degrees = randi() % 360
			planet.generate(CelestialBody.ObjectType.PLANET, zone, mass_for_planets)
			mass_for_planets -= planet.object_mass
			orbit += planet.object_radius
			planet.object_orbit = orbit
			_calculate_orbit_parameters(star, planet, orbit)
			
			var mass_for_moons := planet.get_max_satellites_mass()
			var moon_orbit := planet.object_radius
			while mass_for_moons > CelestialBody.PlanetMass.MIN / 2:
				moon_orbit += Func.randi_from_range(MoonSeparation.MIN, MoonSeparation.MAX)
				var moon: CelestialBody = SCN_BODY.instance()
				planet.add_satellite(moon)
				moon.rotation_degrees = randi() % 360
				moon.generate(CelestialBody.ObjectType.MOON, zone, mass_for_moons)
				mass_for_moons -= moon.object_mass
				moon_orbit += moon.object_radius
				orbit += moon_orbit
				moon.object_orbit = moon_orbit
				_calculate_orbit_parameters(planet, moon, moon_orbit)
		else:
			break


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


func _generate_moon(planet_zone: int, max_mass: int) -> CelestialBody:
	var moon: CelestialBody = SCN_BODY.instance()
	moon.generate(CelestialBody.ObjectType.MOON, planet_zone, max_mass)
	return moon


func _calculate_orbit_parameters(parent: SystemObject, child: SystemObject, orbit: int) -> void:
	assert(orbit > 0, "Orbit must be greater than zero. You entered: %d" % orbit)
	var total_mass := parent.object_mass + child.object_mass
	var orbital_velocity := sqrt(Const.GRAVITATIONAL * total_mass / orbit) / Const.ORBITAL_SPEED_DIVIDER
	orbital_velocity *= 1 if randf() < 0.5 else -1
	child.object_rotation_speed = orbital_velocity


func _on_SolarSystem_visibility_changed() -> void:
	pass # If system is not displayed ten we must disable all collisions inside on every object
