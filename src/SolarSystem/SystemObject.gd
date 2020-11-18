class_name SystemObject
extends Node2D
"""
Orbital velocity of an object is calculated from following equasion:
	velocity = sqrt(G * TM / OR)
Where:
	Gravitational constant G = 6.6743 * 10-11 m³/(kg*s²) = 0.000000000066743 m³/(kg*s²) is way too small for numbers we will have in game.
	Check 'OrbitalSpeed.ods' in 'doc' directory for some suggestions. Maybe 0.0066743 or even 0.00066743
	TM - Total Mass of both bodies
	OR - Orbit Radius

Our star Sun has mass so huge (and it's one of the smallest stars in galaxy) that if we sum up other planets in our system and their moons
they would have less than 1% of Sun mass. This means that mass of our whole solar system is almost equal to Sun mass, because Sun is more
than 99% of it. To avoid so huge numbers in game (Godot doesn't have data type this big) we reduce mass of every solar object by a huge
amount and increase total mass of star orbiting satellites (planets) to SATELLITES_MASS_FACTOR of its mass. This constant is also applied
to mass of moons in relation to mass of planets they will be orbiting.
"""
################################################################# SIGNALS ################################################################
################################################################# ENUMS ##################################################################
enum Type {
	STAR,
	PLANET,
	MOON,
}

enum SatelliteSeparation {
	MIN = 750,
	MAX = 7_500,
}

################################################################# CONSTANTS ##############################################################
const GRAV := 6.6743 * pow(10, -4)	# This is gravitational constant adjusted to numbers in game
const SATELLITES_MASS_FACTOR := 0.1	# Total mass of all satellites around star or planet cannot exceed 10% mass of main body.


################################################################# EXPORT VAR #############################################################
#export (Type) var type: int = Type.STAR setget set_type
var type: int = Type.STAR setget set_type


################################################################# PUBLIC VAR #############################################################
var orbit := 0 setget set_orbit
var body_radius := 1 setget set_body_radius
var body_mass := 0
var rotation_speed := 0.0 setget set_rotation_speed
var temperature := 0.0	# in celsius
var description := ""
var user_comment := ""


################################################################# PRIVATE VAR ############################################################
################################################################# ONREADY VAR ############################################################
onready var body := $StaticBody2D
onready var collision_shape := $StaticBody2D/CollisionShape2D
onready var sprite := $StaticBody2D/Sprite
onready var satellites := $StaticBody2D/Satellites


################################################################# SETTERS & GETTERS ######################################################
func set_body_radius(val: int) -> void:
	assert(val > 0, "Body radius must be greater than 0 (%d)" % val)
	body_radius = val
	collision_shape.shape.radius = body_radius
	_rescale_sprite()


func set_type(val:int) -> void:
	assert(val in Type.values(), "Invalid body type: %d" % val)
	type = val
	satellites.visible = false if val == Type.MOON else true


func set_orbit(val: int) -> void:
	assert(val >= 0, "Orbit height cannot have negative value: %d" % val)
	body.position.x = val


func set_rotation_speed(val: float) -> void:
	rotation_speed = val


################################################################# BUILT-IN METHODS #######################################################
func _ready() -> void:
	set_body_radius(body_radius)


func _physics_process(delta: float) -> void:
	orbital_movement(delta)


################################################################# PUBLIC METHODS #########################################################
func get_type_as_str() -> String:
	var result := ""
	
	match type:
		Type.STAR: result = "star"
		Type.PLANET: result = "planet"
		Type.MOON: result = "moon"
	
	return result


func orbital_movement(delta: float) -> void:
	rotation += rotation_speed * delta
	body.rotation = -rotation


func can_have_satellites() -> bool:
	return satellites.visible


func add_satellite(sat: SystemObject) -> void:
	assert(can_have_satellites(), "Celestial bodies of type %s cannot have sattelites" % get_type_as_str())
	satellites.add_child(sat)


func get_satellites() -> Array:
	return satellites.get_children()


func get_max_satellites_mass() -> float:
	return body_mass * SATELLITES_MASS_FACTOR


################################################################# PRIVATE METHODS ########################################################
func _rescale_sprite() -> void:
	var body_diameter := body_radius * 2.0
	var scale_width: float = body_diameter / sprite.texture.get_width()
	var scale_height: float = body_diameter / sprite.texture.get_height()
	sprite.scale = Vector2(scale_width, scale_height)


func _on_VisibilityEnabler2D_screen_entered() -> void:
	pass


func _on_VisibilityEnabler2D_screen_exited() -> void:
	pass
