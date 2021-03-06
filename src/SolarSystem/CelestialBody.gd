class_name CelestialBody
extends SystemObject
"""
Planet classifications, descriptions and characteristics taken from: https://scifi.media/star-trek/star-trek-planet-classifications/
"""
################################################################# SIGNALS ################################################################
################################################################# ENUMS ##################################################################
enum Zone {
	HOT,
	ECO,
	COLD,
	OUTER
}

enum PlanetRadius {
	REAL_MIN = 50,
	REAL_MAX = 20_000,
	GAME_MIN = 25,
	GAME_MAX = 256
}

enum PlanetMass {
	MIN = 45_500_000,
	MAX = 465_920_000
}

enum MoonRadius {
	REAL_MIN = 5,
	REAL_MAX = 750,
	GAME_MIN = 25,
	GAME_MAX = 64
}

enum MoonMass {
	MIN = 455_000,
	MAX = 4_659_200
}

################################################################# CONSTANTS ##############################################################
const PLANETS_CLASSES := "ABCDEFGHIJKLMNOPQRXY"
const RADIUS_TO_MASS_FACTOR := 18_200
const TEXTURE_RESOLUTIONS := [ 64, 128, 256, 512 ]
const DATA := {	# Most likely this should be in JSON file
		"Texture": {
			64: preload("res://assets/Textures/Planets/Planet 64.png"),
			128: preload("res://assets/Textures/Planets/Planet 128.png"),
			256: preload("res://assets/Textures/Planets/Planet 256.png"),
			512: preload("res://assets/Textures/Planets/Planet 512.png"),
#			"A": preload("res://icon.png"),
#			"B": preload("res://icon.png"),
#			"C": preload("res://icon.png"),
#			"D": preload("res://icon.png"),
#			"E": preload("res://icon.png"),
#			"F": preload("res://icon.png"),
#			"G": preload("res://icon.png"),
#			"H": preload("res://icon.png"),
#			"I": preload("res://icon.png"),
#			"J": preload("res://icon.png"),
#			"K": preload("res://icon.png"),
#			"L": preload("res://icon.png"),
#			"M": preload("res://icon.png"),
#			"N": preload("res://icon.png"),
#			"O": preload("res://icon.png"),
#			"P": preload("res://icon.png"),
#			"Q": preload("res://icon.png"),
#			"R": preload("res://icon.png"),
#			"X": preload("res://icon.png"),
#			"Y": preload("res://icon.png")
		},
		"Modulation": {
			"A": Color(0.98, 0.793963, 0.3234),
			"B": Color(0.61, 0.5612, 0.5612),
			"C": Color(0.4599, 0.608455, 0.73),
			"D": Color(0.6912, 0.72, 0.71616),
			"E": Color(0.91, 0.522947, 0.1092),
			"F": Color(0.2867, 0.61, 0.362137),
			"G": Color(0.76, 0.342, 0),
			"H": Color(0.84, 0.73136, 0.0252),
			"I": Color(0.88, 0.78452, 0.0616),
			"J": Color(0.85, 0.419333, 0.0425),
			"K": Color(1, 0.3825, 0.05),
			"L": Color(0.5922, 0.72, 0.2088),
			"M": Color(0.1472, 0.68816, 0.92),
			"N": Color(0.854683, 0.95, 0.133),
			"O": Color(0.0475, 0.589, 0.95),
			"P": Color(0.87, 0.866955, 0.8613),
			"Q": Color(0.67119, 0.78, 0.0546),
			"R": Color(0.209095, 0.71, 0.1207),
			"X": Color(0.45, 0.2715, 0.0675),
			"Y": Color(0.89, 0.2225, 0.089)
		},
		"Description": {
			"A": 'Class A planets are very small, barren worlds rife with volcanic activity. This activity traps carbon dioxide in the atmosphere and keeps temperatures on Class A planets very hot, no matter the location in a star system. When the volcanic activity ceases, the planet “dies” and is then considered a Class C planet.',
			"B": 'Class B planets are generally small worlds located within a star system’s Hot Zone. Highly unsuited for humanoid life, Class B planets have thin atmospheres composed primarily of helium and sodium. The surface is molten and highly unstable; temperatures range from 450° in the daylight, to nearly -200° at night. No life forms have ever been observed on Class B planetoids.',
			"C": 'When all volcanic activity on a class a planet ceases, it is considered class C. Essentially dead, these small worlds have cold, barren surfaces and possess no geological activity.',
			"D": 'Also known as Plutonian objects, these tiny worlds are composed primarily of ice and are generally not considered true planets. Many moons and asteroids are considered class d, as are the larger objects in a star system’s Kuiper Belt. Most are not suitable for humanoid life, though many can be colonized via pressure domes.',
			"E": 'Class e planets represent the earliest stage in the evolution of a habitable planet. The core and crust is completely molten, making the planets susceptible to solar winds and radiation and subject to extremely high surface temperatures. The atmosphere is very thin, composed of hydrogen and helium. As the surface cools, the core and crust begin to harden, and the planet evolves into a class F world.',
			"F": 'A class E planet makes the transition to class F once the crust and core have begun to harden. Volcanic activity is also commonplace on class f worlds; the steam expelled from volcanic eruptions eventually condenses into water, giving rise to shallow seas in which simple bacteria thrive. When the planet’s core is sufficiently cool, the volcanic activity ceases and the planet is considered class G.',
			"G": 'After the core of a class F planet is sufficiently cool, volcanic activity lessens and the planet is considered class G. Oxygen and nitrogen are present in some abundance in the atmosphere, giving rise to increasingly complex organisms such as primitive vegetation like algae, and animals similar to sponges and jellyfish. As the surface cools, a class G planet can evolve into a class H, K, L, M, N, O, or P class world.',
			"H": 'A planet is considered class H if less than 20% of its surface is water. Though many class H worlds are covered in sand, it is not required to be considered a desert; it must, however, receive little in the way of precipitation. Drought-resistant plants and animals are common on class H worlds, and many are inhabited by humanoid populations. Most class H worlds are hot and arid, but conditions can vary greatly.',
			"I": 'Also known as Uranian planets, these gaseous giants have vastly different compositions from other giant worlds; the core is mostly rock and ice surrounded by a tenuous layers of methane, water, and ammonia. Additionally, the magnetic field is sharply inclined to the axis of rotation. Class I planets typically form on the fringe of a star system.',
			"J": 'Class J planets are massive spheres of liquid and gaseous hydrogen, with small cores of metallic hydrogen. Their atmospheres are extremely turbulent, with wind speeds in the most severe storms reaching 600 kph. Many class j planets also possess impressive ring systems, composed primarily of rock, dust, and ice. They form in the cold zone of a star system, though typically much closer than class I planets.',
			"K": 'Though similar in appearance to class H worlds, class K planets lack the robust atmosphere of their desert counterparts. Though rare, primitive single-celled organisms have been known to exist, though more complex life never evolves. Humanoid colonization is, however, possible through the use of pressure domes and in some cases, terraforming.',
			"L": 'Class L planets are typically rocky, forested worlds devoid of animal life. They are, however, well-suited for humanoid colonization and are prime candidates for terraforming. Water is typically scarce, and if less than 20% of the surface is covered in water, the planet is considered class H.',
			"M": 'Class M planets are robust and varied worlds composed primarily of silicate rocks, and are highly suited for humanoid life. To be considered class M, between 20% and 80% of the surface must be covered in water; it must have a breathable oxygen- nitrogen atmosphere and temperate climate.',
			"N": 'Though frequently found in the ecosphere, class n planets are not conducive to life. The terrain is barren, with surface temperatures in excess of 500° and an atmospheric pressure more than 90 times that of a class-m world. Additionally, the atmosphere is very dense and composed of carbon dioxide; water exists only in the form of thick,vaporous clouds that shroud most of the planet.',
			"O": 'Any planet with more than 80% of the surface covered in water is considered class O. These worlds are usually very warm and possess vast cetacean populations in addition to tropical vegetation and animal life. Though rare, humanoid populations have also formed on class O planets.',
			"P": 'Any planet whose surface is more than 80% frozen is considered class P. These glaciated worlds are typically very cold, with temperatures rarely exceeding the freezing point. Though not prime conditions for life, hearty plants and animals are not uncommon, and some species, such as the Aenar and the Andorians, have evolved on class P worlds.',
			"Q": 'These rare planetoids typically develop with a highly eccentric orbit, or near stars with a variable output. As such, conditions on the planet’s surface are widely varied. Deserts and rain forests exist within a few kilometers of each other, while glaciers can simultaneously lie very near the equator. Given the constant instability, is virtually impossible for life to exist on class-Q worlds.',
			"R": 'A class R planet usually forms within a star system, but at some point in its evolution, the planet is expelled, likely the result of a catastrophic asteroid impact. The shift radically changes the planet’s evolution; many planets merely die, but geologically active planets can sustain a habitable surface via volcanic outgassing and geothermal venting.',
			"X": 'Class X planets are the result of a failed class T planet in a star system’s hot zone. Instead of becoming a gas giant or red dwarf star, a class x planet was stripped of its hydrogen/ helium atmosphere. The result is a small, barren world similar to a class b planet, but with no atmosphere and an extremely dense, metal-rich core',
			"Y": 'Perhaps the most environmentally unfriendly planets in the galaxy, class Y planets are toxic to life in every way imaginable. The atmosphere is saturated with toxic radiation, temperatures are extreme, and atmospheric storms are amongst the most severe in the galaxy, with winds in excess of 500 kph.'
		},
		"ObjectType": {	# Body class can be Planet or Moon. Here we detemine what type of body can it be.
			"A": [ObjectType.PLANET, ObjectType.MOON],
			"B": [ObjectType.PLANET, ObjectType.MOON],
			"C": [ObjectType.PLANET, ObjectType.MOON],
			"D": [ObjectType.MOON],
			"E": [ObjectType.PLANET],
			"F": [ObjectType.PLANET],
			"G": [ObjectType.PLANET],
			"H": [ObjectType.PLANET],
			"I": [ObjectType.PLANET],
			"J": [ObjectType.PLANET],
			"K": [ObjectType.PLANET, ObjectType.MOON],
			"L": [ObjectType.PLANET],
			"M": [ObjectType.PLANET],
			"N": [ObjectType.PLANET],
			"O": [ObjectType.PLANET],
			"P": [ObjectType.PLANET],
			"Q": [ObjectType.PLANET, ObjectType.MOON],
			"R": [ObjectType.PLANET, ObjectType.MOON],
			"X": [ObjectType.PLANET, ObjectType.MOON],
			"Y": [ObjectType.PLANET]
		},
		"Zone": {
			"A": [Zone.ECO, Zone.COLD],
			"B": [Zone.HOT],
			"C": [Zone.ECO, Zone.COLD],
			"D": [Zone.HOT, Zone.ECO, Zone.COLD, Zone.OUTER],
			"E": [Zone.ECO],
			"F": [Zone.ECO],
			"G": [Zone.ECO],
			"H": [Zone.HOT, Zone.ECO, Zone.COLD],
			"I": [Zone.COLD],
			"J": [Zone.COLD],
			"K": [Zone.ECO],
			"L": [Zone.ECO],
			"M": [Zone.ECO],
			"N": [Zone.ECO],
			"O": [Zone.ECO],
			"P": [Zone.ECO],
			"Q": [Zone.HOT, Zone.ECO, Zone.COLD],
			"R": [Zone.OUTER],
			"X": [Zone.HOT],
			"Y": [Zone.HOT, Zone.ECO, Zone.COLD]
		},
		"PlanetRadius": {
			"A": { "Min": 500, "Max": 5000 },
			"B": { "Min": 500, "Max": 5000 },
			"C": { "Min": 500, "Max": 5000 },
			"E": { "Min": 5000, "Max": 7500 },
			"F": { "Min": 5000, "Max": 7500 },
			"G": { "Min": 5000, "Max": 7500 },
			"H": { "Min": 4000, "Max": 7500 },
			"I": { "Min": 10000, "Max": 15000 },
			"J": { "Min": 15000, "Max": 20000 },
			"K": { "Min": 2500, "Max": 5000 },
			"L": { "Min": 5000, "Max": 7500 },
			"M": { "Min": 5000, "Max": 7500 },
			"N": { "Min": 5000, "Max": 7500 },
			"O": { "Min": 5000, "Max": 7500 },
			"P": { "Min": 5000, "Max": 7500 },
			"Q": { "Min": 2000, "Max": 7500 },
			"R": { "Min": 2000, "Max": 7500 },
			"X": { "Min": 500, "Max": 5000 },
			"Y": { "Min": 5000, "Max": 7500 },
		},
		"MoonRadius": {
			"A": { "Min": 5, "Max": 400 },
			"B": { "Min": 5, "Max": 400 },
			"C": { "Min": 5, "Max": 400 },
			"D": { "Min": 5, "Max": 200 },
			"K": { "Min": 5, "Max": 400 },
			"Q": { "Min": 5, "Max": 450 },
			"R": { "Min": 5, "Max": 450 },
			"X": { "Min": 5, "Max": 400 },
		}
	}

################################################################# EXPORT VAR #############################################################
################################################################# PUBLIC VAR #############################################################
################################################################# PRIVATE VAR ############################################################
################################################################# ONREADY VAR ############################################################
################################################################# SETTERS & GETTERS ######################################################
################################################################# BUILT-IN METHODS #######################################################
func _ready() -> void:
	object_type = ObjectType.PLANET


################################################################# PUBLIC METHODS #########################################################
func generate(type: int, zone: int, max_mass: int) -> void:
	assert(type == ObjectType.PLANET || type == ObjectType.MOON, "Invalid body type: %d" % type)
	assert(zone in Zone.values(), "Invalid zone %d" % zone)
	
	self.object_type = type
	var body_class := _get_random_class_in_zone(zone)
	if body_class.empty():
		print("No valid choices left for %s at zone: %d" % [get_object_type_as_str(), zone])
		return
	
	match type:
		ObjectType.PLANET:
			_generate_planet(body_class, max_mass)
		
		ObjectType.MOON:
			_generate_moon(body_class, max_mass)
	
	_select_best_texture_scaled()
	sprite.self_modulate = DATA.Modulation[body_class]
	object_description = DATA.Description[body_class]


################################################################# PRIVATE METHODS ########################################################
#TODO: Add generation of resources, atmosphere etc.
func _generate_planet(body_class: String, max_mass: int) -> void:
	assert(max_mass > PlanetMass.MIN, "Planetary bodies cannot have less mass than %d. Your mass limit is: %d" % [PlanetMass.MIN, max_mass])
	
	var body_mass: int = PlanetMass.MAX + 10_942_867_749_350	# This must be big number so while loop executes at least once
	var game_radius := 0
	while body_mass > max_mass:
		var real_radius := Func.randi_from_range(DATA.PlanetRadius[body_class].Min, DATA.PlanetRadius[body_class].Max)
		game_radius = int(range_lerp(real_radius, PlanetRadius.REAL_MIN, PlanetRadius.REAL_MAX, PlanetRadius.GAME_MIN, PlanetRadius.GAME_MAX))
		body_mass = int(range_lerp(real_radius, PlanetRadius.REAL_MIN, PlanetRadius.REAL_MAX, PlanetMass.MIN, PlanetMass.MAX))
	
	self.object_radius = game_radius
	object_mass = body_mass


#TODO: Add generation of resources, atmosphere etc.
func _generate_moon(body_class: String, max_mass: int) -> void:
	assert(max_mass > MoonMass.MIN, "Moons cannot have less than %d mass. Your mass limit is: %d" % [MoonMass.MIN, max_mass])
	
	var body_mass: int = MoonMass.MAX + 10_942_867_749_350	# This must be big number so while loop executes at least once
	var game_radius := 0
	while body_mass > max_mass:
		var real_radius := Func.randi_from_range(DATA.MoonRadius[body_class].Min, DATA.MoonRadius[body_class].Max)
		game_radius = int(range_lerp(real_radius, MoonRadius.REAL_MIN, MoonRadius.REAL_MAX, MoonRadius.GAME_MIN, MoonRadius.GAME_MAX))
		body_mass = int(range_lerp(real_radius, MoonRadius.REAL_MIN, MoonRadius.REAL_MAX, MoonMass.MIN, MoonMass.MAX))
	
	self.object_radius = game_radius
	object_mass = body_mass


func _get_random_class_in_zone(zone: int) -> String:
	assert(zone in Zone.values(), "Unknown zone type: %d" % zone)
	var class_pool := []
	for body_class in DATA.Zone:
		if zone in DATA.Zone[body_class] && object_type in DATA.ObjectType[body_class]:
			class_pool.append(body_class)
	
	assert(!class_pool.empty(), "No valid class availble in zone %d" % zone)
	return class_pool[randi() % class_pool.size()] if class_pool.size() > 0 else ""


func _select_best_texture_scaled() -> void:
	var body_diameter = object_radius * 2
	var resolution := 0
	for res in TEXTURE_RESOLUTIONS:
		if body_diameter <= res:
			resolution = res
			break
	
	sprite.texture = DATA.Texture[resolution]
	sprite.scale = Vector2(body_diameter, body_diameter) / resolution
