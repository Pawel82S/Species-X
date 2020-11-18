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
################################################################# CONSTANTS ##############################################################
const PLANETS_CLASSES := "ABCDEFGHIJKLMNOPQRSTXY"
const DATA := {	# Most likely this should be in JSON file
		"Texture": {
			"A": preload("res://icon.png"),
			"B": preload("res://icon.png"),
			"C": preload("res://icon.png"),
			"D": preload("res://icon.png"),
			"E": preload("res://icon.png"),
			"F": preload("res://icon.png"),
			"G": preload("res://icon.png"),
			"H": preload("res://icon.png"),
			"I": preload("res://icon.png"),
			"J": preload("res://icon.png"),
			"K": preload("res://icon.png"),
			"L": preload("res://icon.png"),
			"M": preload("res://icon.png"),
			"N": preload("res://icon.png"),
			"O": preload("res://icon.png"),
			"P": preload("res://icon.png"),
			"Q": preload("res://icon.png"),
			"R": preload("res://icon.png"),
			"S": preload("res://icon.png"),
			"T": preload("res://icon.png"),
			"X": preload("res://icon.png"),
			"Y": preload("res://icon.png")
		},
		"Modulation": {
			"A": Color.greenyellow,
			"B": Color.greenyellow,
			"C": Color.greenyellow,
			"D": Color.greenyellow,
			"E": Color.greenyellow,
			"F": Color.greenyellow,
			"G": Color.greenyellow,
			"H": Color.greenyellow,
			"I": Color.greenyellow,
			"J": Color.greenyellow,
			"K": Color.greenyellow,
			"L": Color.greenyellow,
			"M": Color.greenyellow,
			"N": Color.greenyellow,
			"O": Color.greenyellow,
			"P": Color.greenyellow,
			"Q": Color.greenyellow,
			"R": Color.greenyellow,
			"S": Color.greenyellow,
			"T": Color.greenyellow,
			"X": Color.greenyellow,
			"Y": Color.greenyellow
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
			"S": 'Aside from their immense size, Class S planets are very similar to their Class J counterparts, with liquid metallic hydrogen cores surrounded by a hydrogen and helium atmosphere.',
			"T": 'Class T planets represent the upper limits of planetary masses. Most exist within a star system’s cold zone and are very similar to class S and J planets. However, class t planets occasionally form within a star system’s hot zone. If they are sufficiently massive (13 times more massive than Jupiter), deuterium ignites nuclear fusion within the core, and the planet becomes a red dwarf star, creating a binary star system.',
			"X": 'Class X planets are the result of a failed class T planet in a star system’s hot zone. Instead of becoming a gas giant or red dwarf star, a class x planet was stripped of its hydrogen/ helium atmosphere. The result is a small, barren world similar to a class b planet, but with no atmosphere and an extremely dense, metal-rich core',
			"Y": 'Perhaps the most environmentally unfriendly planets in the galaxy, class Y planets are toxic to life in every way imaginable. The atmosphere is saturated with toxic radiation, temperatures are extreme, and atmospheric storms are amongst the most severe in the galaxy, with winds in excess of 500 kph.'
		},
		"Type": {	# Body class can be Planet or Moon. Here we detemine what type of body can it be.
			"A": [Type.PLANET, Type.MOON],
			"B": [Type.PLANET, Type.MOON],
			"C": [Type.PLANET, Type.MOON],
			"D": [Type.MOON],
			"E": [Type.PLANET],
			"F": [Type.PLANET],
			"G": [Type.PLANET],
			"H": [Type.PLANET],
			"I": [Type.PLANET],
			"J": [Type.PLANET],
			"K": [Type.PLANET, Type.MOON],
			"L": [Type.PLANET],
			"M": [Type.PLANET],
			"N": [Type.PLANET],
			"O": [Type.PLANET],
			"P": [Type.PLANET],
			"Q": [Type.PLANET, Type.MOON],
			"R": [Type.PLANET, Type.MOON],
			"S": [Type.PLANET],
			"T": [Type.PLANET],
			"X": [Type.PLANET, Type.MOON],
			"Y": [Type.PLANET]
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
			"S": [Zone.COLD],
			"T": [Zone.COLD],
			"X": [Zone.HOT],
			"Y": [Zone.HOT, Zone.ECO, Zone.COLD]
		}
	}

################################################################# EXPORT VAR #############################################################
################################################################# PUBLIC VAR #############################################################
################################################################# PRIVATE VAR ############################################################
################################################################# ONREADY VAR ############################################################
################################################################# SETTERS & GETTERS ######################################################
################################################################# BUILT-IN METHODS #######################################################
func _ready() -> void:
	type = Type.PLANET


################################################################# PUBLIC METHODS #########################################################
func generate(body_type: int, zone: int, max_mass: int) -> void:
	assert(body_type == Type.PLANET || body_type == Type.MOON, "Invalid body type: %d" % body_type)
	assert(zone in Zone.values(), "Invalid zone %d" % zone)
	assert(max_mass > 0, "Celestial bodies cannot have zero or less mass. You requested: %d" % max_mass)
	
	self.type = body_type
	var body_class := _get_random_class_in_zone(zone)
	if body_class.empty():
		print("No valid choices left for %s at zone: %d" % [get_type_as_str(), zone])
		return


################################################################# PRIVATE METHODS ########################################################
func _get_random_class_in_zone(zone: int) -> String:
	assert(zone in Zone.values(), "Unknown zone type: %d" % zone)
	var class_pool := []
	for body_class in DATA["Zone"]:
		if zone in DATA["Zone"][body_class] && type in DATA["Type"][body_class]:
			class_pool.append(body_class)
	
	return class_pool[randi() % class_pool.size()] if class_pool.size() > 0 else ""
