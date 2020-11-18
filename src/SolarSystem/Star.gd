class_name Star
extends SystemObject
"""
Data in this script are loosely based on article in Wikipedia: https://en.wikipedia.org/wiki/Stellar_classification. Every time when using
real data would be hard or impossible, data will be altered to fit game mechanics (ie. body_mass and size of stars will be greatly reduced).

Main sequence stars (Harvard spectral classification) in alphabetic order (this is about 99% of stars on our sky):
		Temperature	  | Chromacity		   | Sun Mass	 | Sun Radius  | Luminosity | Hydrogen lines | Fraction of all
	A:= 7.5kK - 10kK  | blue			   | 1.4 - 2.1	 | 1.4 - 1.8   | 5 - 25		| Strong		 | 0.6%
	B:= 10kK - 30kK	  | deep blue white	   | 2.1 - 16	 | 1.8 - 6.6   | 25 - 30k	| Medium		 | 0.13%
	F:= 6kK - 7.5kK	  | white			   | 1.04 - 1.4	 | 1.15 - 1.4  | 1.5 - 5	| Medium		 | 3%
	G:= 5.2kK - 6kK	  | yellowish white	   | 0.8 - 1.04	 | 0.96 - 1.15 | 0.6 - 1.5	| Weak			 | 7.6%
	K:= 3.7kK - 5.2kK | pale yellow orange | 0.45 - 0.8	 | 0.7 - 0.96  | 0.08 - 0.6 | Very weak		 | 12.1%
	M:= 2.4kK - 3.7kK | light orange red   | 0.08 - 0.45 | 0.35? - 0.7 | <= 0.08	| Very weak		 | 76.45%
	O:= 30kK - 52kK	  | blue			   | >= 16 - 50? | >= 6.6	   | >= 30k		| Weak			 | 0.00003%
																									   99.78003%
First thing that will be adjusted is chance of occurance, because some types like 'O', 'B' and 'A' have so low chances in reality that
implementing them in game would be a waste of time. Besides main sequence stars are more than 99.7% of all stars so we will reduce occurence
of them to fit Quasars, Black holes and Neutron stars(Pulsars, Magnetars) which will be included in game.

About Black Holes (https://en.wikipedia.org/wiki/Black_hole):
'Black holes of stellar body_mass are expected to form when very massive stars collapse at the end of their life cycle. After a black hole has
formed, it can continue to grow by absorbing body_mass from its surroundings. By absorbing other stars and merging with other black holes,
supermassive black holes of millions of solar masses (M☉) may form. There is consensus that supermassive black holes exist in the centers of
most galaxies.'
Now we know that every galaxy must have one supermassive black hole or quasar in the center to keep other systems around it. I don't think
this will be playable area for game because I can't think of technology capable of withstanding such massive gravity force, unless we want
player and AI to loose everything that goes near it.

About Neutron stars: Pulsars, Magnetars and Magnetar+Pulsar (https://en.wikipedia.org/wiki/Neutron_star):
'Neutron stars that can be observed are very hot and typically have a surface temperature of around 600000 K. They are so dense that a
normal-sized matchbox containing neutron-star material would have a weight of approximately 3 billion tonnes, the same weight as a 0.5 cubic
kilometre chunk of the Earth (a cube with edges of about 800 metres) from Earth's surface. Their magnetic fields are between 108 and 1015
(100 million to 1 quadrillion) times stronger than Earth's magnetic field. The gravitational field at the neutron star's surface is about
2×10^11 (200 billion) times that of Earth's gravitational field.'
"""
################################################################# SIGNALS ################################################################
################################################################# ENUMS ##################################################################
enum SubType {
	NORMAL,
	MAGNETAR, # Neutron star
	PULSAR, # Neutron star
	MAGNETAR_PULSAR, # Neutron star
	BLACK_HOLE
}

################################################################# CONSTANTS ##############################################################
const RANDOM_STAR_TYPE := -1
const NORMAL_STAR_CLASSES_CHANCE := 95	# How much chance we have to generate star from main sequence in %
const NORMAL_STAR_CLASSES_OCCURENCE := "ABFFGGGGGKKKKKKKKMMMMMMMMMMMMMMMMMMMMMMMMMO"
const DEFAULT_SUN_RADIUS := 500
const DEFAULT_SUN_MASS := 198_857_354_987	# Sun body_mass = 1.9885 * 10^30 kg
const DEFAULT_SUN_TEMP := 5498.85
const DATA := {	# Most likely this should be in JSON file
		"Texture": {
			"A": preload("res://assets/Textures/Stars/Star.png"),
			"B": preload("res://assets/Textures/Stars/Star.png"),
			"F": preload("res://assets/Textures/Stars/Star.png"),
			"G": preload("res://assets/Textures/Stars/Star.png"),
			"K": preload("res://assets/Textures/Stars/Star.png"),
			"M": preload("res://assets/Textures/Stars/Star.png"),
			"O": preload("res://assets/Textures/Stars/Star.png"),
			"Magnetar": preload("res://assets/Textures/Stars/Star.png"),
			"Pulsar": preload("res://assets/Textures/Stars/Star.png"),
			"MagnetarPulsar": preload("res://assets/Textures/Stars/Star.png"),
			"BlackHole": preload("res://assets/Textures/Stars/Star.png")
		},
		"Modulation": {
			"A": Color.blue,
			"B": Color.deepskyblue,
			"F": Color.white,
			"G": Color.floralwhite,
			"K": Color.orange,
			"M": Color.orangered,
			"O": Color.aqua,
			"Magnetar": Color.pink,
			"Pulsar": Color.pink,
			"MagnetarPulsar": Color.pink,
			"BlackHole": Color.pink
		},
		"Description": {
			"A": "Class A star",
			"B": "Class B star",
			"F": "Class F star",
			"G": "Class G star",
			"K": "Class K star",
			"M": "Class M star",
			"O": "Class O star",
			"Magnetar": "Magnetar",
			"Pulsar": "Pulsar",
			"MagnetarPulsar": "Magnetar-Pulsar",
			"BlackHole": "Black Hole"
		}
	}

################################################################# EXPORT VAR #############################################################
################################################################# PUBLIC VAR #############################################################
var subtype: int = SubType.NORMAL setget set_subtype
var luminosity := 0.0
var color := Color.white


################################################################# PRIVATE VAR ############################################################
################################################################# ONREADY VAR ############################################################
################################################################# SETTERS & GETTERS ######################################################
func set_subtype(val: int) -> void:
	assert(val in SubType.values(), "Invalid star subtype: %d" % val)
	subtype = val


################################################################# BUILT-IN METHODS #######################################################
func _ready() -> void:
	type = Type.STAR


################################################################# PUBLIC METHODS #########################################################
func get_type_as_str() -> String:
	var result := ""
	
	match subtype:
		SubType.NORMAL: result = "normal"
		SubType.MAGNETAR: result = "magnetar"
		SubType.PULSAR: result = "pulsar"
		SubType.MAGNETAR_PULSAR: result = "magnetar + pulsar"
		SubType.BLACK_HOLE: result = "black hole"
	
	return result


# This function is responsible for random star and its possible sattelites generation. We can also pass specific subtype be created.
func generate(stype: int = RANDOM_STAR_TYPE) -> void:
	assert(stype in SubType.values() || stype == RANDOM_STAR_TYPE, "Function parameter outside of valid range (stype = %d)." % stype)
	if stype == SubType.NORMAL || (stype == RANDOM_STAR_TYPE && randi() % 100 < NORMAL_STAR_CLASSES_CHANCE):
		subtype = SubType.NORMAL
	elif stype in SubType.values():
		if stype == RANDOM_STAR_TYPE:
			# We can roll SubType.NORMAL which is case already handeled before so we must roll until something else occures.
			while subtype == SubType.NORMAL:
				subtype = randi() % SubType.size()
		else:
			subtype = stype
	else:	# Theoretically we should never get here
		print("Cannot generate star of subtype %d, there is only %d types of stars" % [stype, SubType.size()])
		return
	
	match subtype:
		SubType.NORMAL:
			_generate_normal_star()
		
		SubType.MAGNETAR:
			_generate_magnetar_star()
		
		SubType.PULSAR:
			_generate_pulsar_star()
		
		SubType.MAGNETAR_PULSAR:
			_generate_magnetar_pulsar()
		
		SubType.BLACK_HOLE:
			_generate_black_hole()


################################################################# PRIVATE METHODS ########################################################
func _generate_normal_star() -> void:
	match NORMAL_STAR_CLASSES_OCCURENCE[randi() % NORMAL_STAR_CLASSES_OCCURENCE.length()]:
		"A": _generate_star_a()
		"B": _generate_star_b()
		"F": _generate_star_f()
		"G": _generate_star_g()
		"K": _generate_star_k()
		"M": _generate_star_m()
		"O": _generate_star_o()


func _generate_magnetar_star() -> void:
	sprite.texture = DATA["Texture"]["Magnetar"]
	sprite.self_modulate = DATA["Modulation"]["Magnetar"]
	description = DATA["Description"]["Magnetar"]
	# This is neutron star so we will use generic neutron star generation code for now
	_generate_neutron_star()
	print("Magnetar star generation not implemented")


func _generate_pulsar_star() -> void:
	sprite.texture = DATA["Texture"]["Pulsar"]
	sprite.self_modulate = DATA["Modulation"]["Pulsar"]
	description = DATA["Description"]["Pulsar"]
	# This is neutron star so we will use generic neutron star generation code for now
	_generate_neutron_star()
	print("Pulsar star generation not implemented")


func _generate_magnetar_pulsar() -> void:
	sprite.texture = DATA["Texture"]["MagnetarPulsar"]
	sprite.self_modulate = DATA["Modulation"]["MagnetarPulsar"]
	description = DATA["Description"]["MagnetarPulsar"]
	# This is neutron star so we will use generic neutron star generation code for now
	_generate_neutron_star()
	print("Magnetar + Pulsar star generation not implemented")


func _generate_neutron_star() -> void:
	var min_mass := DEFAULT_SUN_MASS * 1.1
	var max_mass := DEFAULT_SUN_MASS * 2.16
	body_mass = Func.randi_from_range(min_mass, max_mass)
	# From https://en.wikipedia.org/wiki/Neutron_star:
	# Neutron stars that can be observed are very hot and typically have a surface temperature of around 600000 K
	temperature = Func.celsius_from_kelvin(Func.randf_from_range(550_000, 650_000))
	self.body_radius = int(range_lerp(body_mass, min_mass, max_mass, 50, 75))


func _generate_black_hole() -> void:
	sprite.texture = DATA["Texture"]["BlackHole"]
	sprite.self_modulate = DATA["Modulation"]["BlackHole"]
	description = DATA["Description"]["BlackHole"]
	# Size of stars is dependent on their body_mass (bigger body_mass, bigger star)
#	self.body_radius = range_lerp(body_mass, min_mass, max_mass, DEFAULT_SUN_RADIUS * 1.4, DEFAULT_SUN_RADIUS * 1.8)
	print("Black hole generation not implemented")


func _generate_star_a() -> void:
	sprite.texture = DATA["Texture"]["A"]
	sprite.self_modulate = DATA["Modulation"]["A"]
	description = DATA["Description"]["A"]
	temperature = Func.celsius_from_kelvin(Func.randi_from_range(7_500, 10_000))
	var min_mass := DEFAULT_SUN_MASS * 1.4
	var max_mass := DEFAULT_SUN_MASS * 2.1
	body_mass = Func.randi_from_range(min_mass, max_mass)
	# Size of stars is dependent on their body_mass (bigger body_mass, bigger star)
	self.body_radius = int(range_lerp(body_mass, min_mass, max_mass, DEFAULT_SUN_RADIUS * 1.4, DEFAULT_SUN_RADIUS * 1.8))
	print("Star subtype A generation not implemented")


func _generate_star_b() -> void:
	sprite.texture = DATA["Texture"]["B"]
	sprite.self_modulate = DATA["Modulation"]["B"]
	description = DATA["Description"]["B"]
	temperature = Func.celsius_from_kelvin(Func.randi_from_range(10_000, 30_000))
	var min_mass := DEFAULT_SUN_MASS * 2.1
	var max_mass := DEFAULT_SUN_MASS * 16
	body_mass = Func.randi_from_range(min_mass, max_mass)
	# Size of stars is dependent on their body_mass (bigger body_mass, bigger star)
	self.body_radius = int(range_lerp(body_mass, min_mass, max_mass, DEFAULT_SUN_RADIUS * 1.8, DEFAULT_SUN_RADIUS * 6.6))
	print("Star subtype B generation not implemented")


func _generate_star_f() -> void:
	sprite.texture = DATA["Texture"]["F"]
	sprite.self_modulate = DATA["Modulation"]["F"]
	description = DATA["Description"]["F"]
	temperature = Func.celsius_from_kelvin(Func.randi_from_range(7_500, 10_000))
	var min_mass := DEFAULT_SUN_MASS * 1.04
	var max_mass := DEFAULT_SUN_MASS * 1.4
	body_mass = Func.randi_from_range(min_mass, max_mass)
	# Size of stars is dependent on their body_mass (bigger body_mass, bigger star)
	self.body_radius = int(range_lerp(body_mass, min_mass, max_mass, DEFAULT_SUN_RADIUS * 1.15, DEFAULT_SUN_RADIUS * 1.4))
	print("Star subtype F generation not implemented")


func _generate_star_g() -> void:
	sprite.texture = DATA["Texture"]["G"]
	sprite.self_modulate = DATA["Modulation"]["G"]
	description = DATA["Description"]["G"]
	temperature = Func.celsius_from_kelvin(Func.randi_from_range(6_000, 7_500))
	var min_mass := DEFAULT_SUN_MASS * 0.8
	var max_mass := DEFAULT_SUN_MASS * 1.04
	body_mass = Func.randi_from_range(min_mass, max_mass)
	# Size of stars is dependent on their body_mass (bigger body_mass, bigger star)
	self.body_radius = int(range_lerp(body_mass, min_mass, max_mass, DEFAULT_SUN_RADIUS * 0.96, DEFAULT_SUN_RADIUS * 1.15))
	print("Star subtype G generation not implemented")


func _generate_star_k() -> void:
	sprite.texture = DATA["Texture"]["K"]
	sprite.self_modulate = DATA["Modulation"]["K"]
	description = DATA["Description"]["K"]
	temperature = Func.celsius_from_kelvin(Func.randi_from_range(3_700, 5_200))
	var min_mass := DEFAULT_SUN_MASS * 0.45
	var max_mass := DEFAULT_SUN_MASS * 0.8
	body_mass = Func.randi_from_range(min_mass, max_mass)
	# Size of stars is dependent on their body_mass (bigger body_mass, bigger star)
	self.body_radius = int(range_lerp(body_mass, min_mass, max_mass, DEFAULT_SUN_RADIUS * 0.7, DEFAULT_SUN_RADIUS * 0.96))
	print("Star subtype K generation not implemented")


func _generate_star_m() -> void:
	sprite.texture = DATA["Texture"]["M"]
	sprite.self_modulate = DATA["Modulation"]["M"]
	description = DATA["Description"]["M"]
	temperature = Func.celsius_from_kelvin(Func.randi_from_range(2_400, 3_700))
	var min_mass := DEFAULT_SUN_MASS * 0.08
	var max_mass := DEFAULT_SUN_MASS * 0.45
	body_mass = Func.randi_from_range(min_mass, max_mass)
	# Size of stars is dependent on their body_mass (bigger body_mass, bigger star)
	# Min radius (0.35) is just my guess
	self.body_radius = int(range_lerp(body_mass, min_mass, max_mass, DEFAULT_SUN_RADIUS * 0.35, DEFAULT_SUN_RADIUS * 0.7))
	print("Star subtype M generation not implemented")


func _generate_star_o() -> void:
	sprite.texture = DATA["Texture"]["O"]
	sprite.self_modulate = DATA["Modulation"]["O"]
	description = DATA["Description"]["O"]
	temperature = Func.celsius_from_kelvin(Func.randi_from_range(30_000, 52_000))
	var min_mass := DEFAULT_SUN_MASS * 16
	# Maximum (50) is just pure guess, because nowhere in Wikipedia is written how many times massive can be this subtype of star. They say
	# howerver that most of them are closer to the lower end (16) and stars can't be bigger than 120-150 times body_mass of our Sun. Source:
	# https://en.wikipedia.org/wiki/O-type_star
	var max_mass := DEFAULT_SUN_MASS * 50
	body_mass = Func.randi_from_range(min_mass, max_mass)
	# Size of stars is dependent on their body_mass (bigger body_mass, bigger star)
	# Max radius (20) is just my guess
	self.body_radius = int(range_lerp(body_mass, min_mass, max_mass, DEFAULT_SUN_RADIUS * 6.6, DEFAULT_SUN_RADIUS * 20))
	print("Star subtype O generation not implemented")
