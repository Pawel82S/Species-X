class_name Star
extends SystemObject
"""
Data in this script are loosely based on article in Wikipedia: https://en.wikipedia.org/wiki/Stellar_classification. Every time when using
real data would be hard or impossible, data will be altered to fit game mechanics (ie. object_mass and size of stars will be greatly reduced).

Main sequence stars (Harvard spectral classification) in alphabetic order (this is about 99% of stars on our sky):
		Temperature	  | Chromacity		   | Sun Mass	 | Sun Radius  | Luminosity | Hydrogen lines | Fraction of all
	A:= 7.5kK - 10kK  | blue			   | 1.4 - 2.1	 | 1.4 - 1.8   | 5 - 25		| Strong		 | 0.6%
	B:= 10kK - 30kK	  | deep blue white	   | 2.1 - 16	 | 1.8 - 6.6[3]   | 25 - 30k	| Medium		 | 0.13%
	F:= 6kK - 7.5kK	  | white			   | 1.04 - 1.4	 | 1.15 - 1.4  | 1.5 - 5	| Medium		 | 3%
	G:= 5.2kK - 6kK	  | yellowish white	   | 0.8 - 1.04	 | 0.96 - 1.15 | 0.6 - 1.5	| Weak			 | 7.6%
	K:= 3.7kK - 5.2kK | pale yellow orange | 0.45 - 0.8	 | 0.7 - 0.96  | 0.08 - 0.6 | Very weak		 | 12.1%
	M:= 2.4kK - 3.7kK | light orange red   | 0.08 - 0.45 | 0.35? - 0.7 | <= 0.08	| Very weak		 | 76.45%
	O:= 30kK - 52kK	  | blue			   | >= 16 - 50? | >= 6.6[3-4]	   | >= 30k		| Weak			 | 0.00003%
																									   99.78003%
NOTE: B and O class star radius was changed to smaller because biggest texture size is 4k (4096) which means without upscaling it and making
graphic worse max radius of star can be 2048px.

First thing that will be adjusted is chance of occurance, because some types like 'O', 'B' and 'A' have so low chances in reality that
implementing them in game would be a waste of time. Besides main sequence stars are more than 99.7% of all stars so we will reduce occurence
of them to fit Quasars, Black holes and Neutron stars(Pulsars, Magnetars) which will be included in game.

About Black Holes (https://en.wikipedia.org/wiki/Black_hole):
'Black holes of stellar object_mass are expected to form when very massive stars collapse at the end of their life cycle. After a black hole has
formed, it can continue to grow by absorbing object_mass from its surroundings. By absorbing other stars and merging with other black holes,
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
enum StarType {
	NORMAL,
	MAGNETAR, # Neutron star
	PULSAR, # Neutron star
	MAGNETAR_PULSAR, # Neutron star
	BLACK_HOLE
}

################################################################# CONSTANTS ##############################################################
const NORMAL_STAR_CLASSES_CHANCE := 95	# How much chance we have to generate star from main sequence in %
const NORMAL_STAR_CLASSES_OCCURENCE := "ABFFGGGGGKKKKKKKKMMMMMMMMMMMMMMMMMMMMMMMMMO"
const DEFAULT_SUN_RADIUS := 500
const DEFAULT_SUN_MASS := 198_857_354_987	# Sun object_mass = 1.9885 * 10^30 kg
const DEFAULT_SUN_TEMP := 5498.85
const TEXTURE_RESOLUTIONS := [ 256, 512, 1024, 2048, 4096 ]
const DATA := {	# Most likely this should be in JSON file
		"Texture": {
			"Normal32": preload("res://assets/Textures/Stars/Star 32.png"),
			"Normal64": preload("res://assets/Textures/Stars/Star 64.png"),
			"Normal256": preload("res://assets/Textures/Stars/Star 256.png"),
			"Normal512": preload("res://assets/Textures/Stars/Star 512.png"),
			"Normal1024": preload("res://assets/Textures/Stars/Star 1024.png"),
			"Normal2048": preload("res://assets/Textures/Stars/Star 2048.png"),
			"Normal4096": preload("res://assets/Textures/Stars/Star 4096.png"),
#			"A": preload("res://assets/Textures/Stars/Star.png"),
#			"B": preload("res://assets/Textures/Stars/Star.png"),
#			"F": preload("res://assets/Textures/Stars/Star.png"),
#			"G": preload("res://assets/Textures/Stars/Star.png"),
#			"K": preload("res://assets/Textures/Stars/Star.png"),
#			"M": preload("res://assets/Textures/Stars/Star.png"),
#			"O": preload("res://assets/Textures/Stars/Star.png"),
			"Magnetar64": preload("res://assets/Textures/Stars/Magnetar 64.png"),
			"Magnetar256": preload("res://assets/Textures/Stars/Magnetar 256.png"),
			"Pulsar64": preload("res://assets/Textures/Stars/Pulsar 64.png"),
			"Pulsar256": preload("res://assets/Textures/Stars/Pulsar 256.png"),
			"MagnetarPulsar64": preload("res://assets/Textures/Stars/Magnetar Pulsar 64.png"),
			"MagnetarPulsar256": preload("res://assets/Textures/Stars/Magnetar Pulsar 256.png"),
			"BlackHole64": preload("res://assets/Textures/Stars/Black Hole 64.png"),
			"BlackHole256": preload("res://assets/Textures/Stars/Black Hole 256.png")
		},
		"Modulation": {
			"A": Color.blue,
			"B": Color.deepskyblue,
			"F": Color.white,
			"G": Color.floralwhite,
			"K": Color.orange,
			"M": Color.orangered,
			"O": Color.aqua,
			"Magnetar": Color.white,
			"Pulsar": Color.white,
			"MagnetarPulsar": Color.white,
			"BlackHole": Color.white
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
var star_type: int = StarType.NORMAL setget set_star_type
var luminosity := 0.0
var color := Color.white
var icon: Texture = DATA.Texture.Normal64


################################################################# PRIVATE VAR ############################################################
################################################################# ONREADY VAR ############################################################
################################################################# SETTERS & GETTERS ######################################################
func set_star_type(val: int) -> void:
	assert(val in StarType.values(), "Invalid star star_type: %d" % val)
	star_type = val


################################################################# BUILT-IN METHODS #######################################################
func _ready() -> void:
	object_type = ObjectType.STAR


################################################################# PUBLIC METHODS #########################################################
func get_type_as_str() -> String:
	var result := ""
	
	match star_type:
		StarType.NORMAL: result = "normal"
		StarType.MAGNETAR: result = "magnetar"
		StarType.PULSAR: result = "pulsar"
		StarType.MAGNETAR_PULSAR: result = "magnetar + pulsar"
		StarType.BLACK_HOLE: result = "black hole"
	
	return result


# This function is responsible for random star and its possible sattelites generation. We can also pass specific star_type be created.
func generate(stype: int = Const.RANDOM) -> void:
	assert(stype in StarType.values() || stype == Const.RANDOM, "Function parameter outside of valid range (stype = %d)." % stype)
	if stype == StarType.NORMAL || (stype == Const.RANDOM && randi() % 100 < NORMAL_STAR_CLASSES_CHANCE):
		star_type = StarType.NORMAL
	elif stype == Const.RANDOM:
		# We can roll StarType.NORMAL which is case already handeled before so we must roll until something else occures.
		while star_type == StarType.NORMAL:
			star_type = randi() % StarType.size()
	else:
		star_type = stype
#	else:	# Theoretically we should never get here
#		print("Cannot generate star of star_type %d, there is only %d types of stars" % [stype, StarType.size()])
#		return
#	star_type = StarType.NORMAL
	match star_type:
		StarType.NORMAL:
			_generate_normal_star()
			_assign_best_texture_scaled()
		
		StarType.MAGNETAR:
			_generate_magnetar_star()
		
		StarType.PULSAR:
			_generate_pulsar_star()
		
		StarType.MAGNETAR_PULSAR:
			_generate_magnetar_pulsar()
		
		StarType.BLACK_HOLE:
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
	sprite.texture = DATA.Texture.Magnetar256
	icon = DATA.Texture.Magnetar64
	sprite.self_modulate = DATA.Modulation.Magnetar
	color = DATA.Modulation.Magnetar
	object_description = DATA.Description.Magnetar
	# This is neutron star so we will use generic neutron star generation code for now
	_generate_neutron_star()


func _generate_pulsar_star() -> void:
	sprite.texture = DATA.Texture.Pulsar256
	icon = DATA.Texture.Pulsar64
	sprite.self_modulate = DATA.Modulation.Pulsar
	color = DATA.Modulation.Pulsar
	object_description = DATA.Description.Pulsar
	# This is neutron star so we will use generic neutron star generation code for now
	_generate_neutron_star()


func _generate_magnetar_pulsar() -> void:
	sprite.texture = DATA.Texture.MagnetarPulsar256
	icon = DATA.Texture.MagnetarPulsar64
	sprite.self_modulate = DATA.Modulation.MagnetarPulsar
	color = DATA.Modulation.MagnetarPulsar
	object_description = DATA.Description.MagnetarPulsar
	# This is neutron star so we will use generic neutron star generation code for now
	_generate_neutron_star()


func _generate_neutron_star() -> void:
	var min_mass := DEFAULT_SUN_MASS * 1.1
	var max_mass := DEFAULT_SUN_MASS * 2.16
	object_mass = Func.randi_from_range(min_mass, max_mass)
	# From https://en.wikipedia.org/wiki/Neutron_star:
	# Neutron stars that can be observed are very hot and typically have a surface temperature of around 600000 K
	object_temperature = Func.celsius_from_kelvin(Func.randf_from_range(550_000, 650_000))
	self.object_radius = 128	#	Texture is 256x256


func _generate_black_hole() -> void:
	icon = DATA.Texture.BlackHole64
	color = DATA.Modulation.BlackHole
	sprite.texture = DATA.Texture.BlackHole256
	sprite.self_modulate = DATA.Modulation.BlackHole
	object_description = DATA.Description.BlackHole
	# Size of stars is dependent on their object_mass (bigger object_mass, bigger star)
	satellites.visible = false
	object_mass = int(INF)
	self.object_radius = 128


func _generate_star_a() -> void:
	icon = DATA.Texture.Normal64
	color = DATA.Modulation.A
	sprite.self_modulate = DATA.Modulation.A
	object_description = DATA.Description.A
	object_temperature = Func.celsius_from_kelvin(Func.randi_from_range(7_500, 10_000))
	var min_mass := DEFAULT_SUN_MASS * 1.4
	var max_mass := DEFAULT_SUN_MASS * 2.1
	object_mass = Func.randi_from_range(min_mass, max_mass)
	# Size of stars is dependent on their object_mass (bigger object_mass, bigger star)
	self.object_radius = int(range_lerp(object_mass, min_mass, max_mass, DEFAULT_SUN_RADIUS * 1.4, DEFAULT_SUN_RADIUS * 1.8))


func _generate_star_b() -> void:
	icon = DATA.Texture.Normal64
	color = DATA.Modulation.B
	sprite.self_modulate = DATA.Modulation.B
	object_description = DATA.Description.B
	object_temperature = Func.celsius_from_kelvin(Func.randi_from_range(10_000, 30_000))
	var min_mass := DEFAULT_SUN_MASS * 2.1
	var max_mass := DEFAULT_SUN_MASS * 16
	object_mass = Func.randi_from_range(min_mass, max_mass)
	# Size of stars is dependent on their object_mass (bigger object_mass, bigger star)
	self.object_radius = int(range_lerp(object_mass, min_mass, max_mass, DEFAULT_SUN_RADIUS * 1.8, DEFAULT_SUN_RADIUS * 3))


func _generate_star_f() -> void:
	icon = DATA.Texture.Normal64
	color = DATA.Modulation.F
	sprite.self_modulate = DATA.Modulation.F
	object_description = DATA.Description.F
	object_temperature = Func.celsius_from_kelvin(Func.randi_from_range(7_500, 10_000))
	var min_mass := DEFAULT_SUN_MASS * 1.04
	var max_mass := DEFAULT_SUN_MASS * 1.4
	object_mass = Func.randi_from_range(min_mass, max_mass)
	# Size of stars is dependent on their object_mass (bigger object_mass, bigger star)
	self.object_radius = int(range_lerp(object_mass, min_mass, max_mass, DEFAULT_SUN_RADIUS * 1.15, DEFAULT_SUN_RADIUS * 1.4))


func _generate_star_g() -> void:
	icon = DATA.Texture.Normal64
	color = DATA.Modulation.G
	sprite.self_modulate = DATA.Modulation.G
	object_description = DATA.Description.G
	object_temperature = Func.celsius_from_kelvin(Func.randi_from_range(6_000, 7_500))
	var min_mass := DEFAULT_SUN_MASS * 0.8
	var max_mass := DEFAULT_SUN_MASS * 1.04
	object_mass = Func.randi_from_range(min_mass, max_mass)
	# Size of stars is dependent on their object_mass (bigger object_mass, bigger star)
	self.object_radius = int(range_lerp(object_mass, min_mass, max_mass, DEFAULT_SUN_RADIUS * 0.96, DEFAULT_SUN_RADIUS * 1.15))


func _generate_star_k() -> void:
	icon = DATA.Texture.Normal64
	color = DATA.Modulation.K
	sprite.self_modulate = DATA.Modulation.K
	object_description = DATA.Description.K
	object_temperature = Func.celsius_from_kelvin(Func.randi_from_range(3_700, 5_200))
	var min_mass := DEFAULT_SUN_MASS * 0.45
	var max_mass := DEFAULT_SUN_MASS * 0.8
	object_mass = Func.randi_from_range(min_mass, max_mass)
	# Size of stars is dependent on their object_mass (bigger object_mass, bigger star)
	self.object_radius = int(range_lerp(object_mass, min_mass, max_mass, DEFAULT_SUN_RADIUS * 0.7, DEFAULT_SUN_RADIUS * 0.96))


func _generate_star_m() -> void:
	icon = DATA.Texture.Normal64
	color = DATA.Modulation.M
	sprite.self_modulate = DATA.Modulation.M
	object_description = DATA.Description.M
	object_temperature = Func.celsius_from_kelvin(Func.randi_from_range(2_400, 3_700))
	var min_mass := DEFAULT_SUN_MASS * 0.08
	var max_mass := DEFAULT_SUN_MASS * 0.45
	object_mass = Func.randi_from_range(min_mass, max_mass)
	# Size of stars is dependent on their object_mass (bigger object_mass, bigger star)
	# Min radius (0.35) is just my guess
	self.object_radius = int(range_lerp(object_mass, min_mass, max_mass, DEFAULT_SUN_RADIUS * 0.35, DEFAULT_SUN_RADIUS * 0.7))


func _generate_star_o() -> void:
	icon = DATA.Texture.Normal64
	color = DATA.Modulation.O
	sprite.self_modulate = DATA.Modulation.O
	object_description = DATA.Description.O
	object_temperature = Func.celsius_from_kelvin(Func.randi_from_range(30_000, 52_000))
	var min_mass := DEFAULT_SUN_MASS * 16
	# Maximum (50) is just pure guess, because nowhere in Wikipedia is written how many times massive can be this subtype of star. They say
	# howerver that most of them are closer to the lower end (16) and stars can't be bigger than 120-150 times object_mass of our Sun. Source:
	# https://en.wikipedia.org/wiki/O-type_star
	var max_mass := DEFAULT_SUN_MASS * 50
	object_mass = Func.randi_from_range(min_mass, max_mass)
	# Size of stars is dependent on their object_mass (bigger object_mass, bigger star)
	# Max radius (20) is just my guess
	self.object_radius = int(range_lerp(object_mass, min_mass, max_mass, DEFAULT_SUN_RADIUS * 3, DEFAULT_SUN_RADIUS * 4))


func _assign_best_texture_scaled() -> void:
	var resolution := 0
	var object_diameter := object_radius * 2
	for res in TEXTURE_RESOLUTIONS:
		if object_diameter <= res:
			resolution = res
			break
	assert(resolution > 0, "Could not find proper texture resolution for Star radius: %d" % object_radius)
	
	match star_type:
		StarType.NORMAL:
			sprite.texture = DATA.Texture["Normal%d" % resolution]
		
		StarType.MAGNETAR:
			_generate_magnetar_star()
		
		StarType.PULSAR:
			_generate_pulsar_star()
		
		StarType.MAGNETAR_PULSAR:
			_generate_magnetar_pulsar()
		
		StarType.BLACK_HOLE:
			_generate_black_hole()
	
	sprite.scale = Vector2(object_diameter, object_diameter) / resolution
