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

WARNING: Running physics simulation on every celestial body every frame is big NO. _physics_process takes 200ms wich means game would run
at 5 FPS! I have to find way to sumulate passing time without involving physics. By storing time and disabling _physics_process  I was able
to reduce frame time to around 16ms which is ~60 FPS in debug mode. I expect FPS will get higher in realease
"""
################################################################# SIGNALS ################################################################
################################################################# ENUMS ##################################################################
enum ObjectType {
	STAR,
	PLANET,
	MOON,
}

################################################################# CONSTANTS ##############################################################
const SATELLITES_MASS_FACTOR := 0.1	# Total mass of all satellites around star or planet cannot exceed 10% mass of main body.


################################################################# EXPORT VAR #############################################################
################################################################# PUBLIC VAR #############################################################
var object_type: int = ObjectType.STAR setget set_object_type
var object_name := "" setget set_object_name
var object_orbit := 0 setget set_object_orbit
var object_radius := 1 setget set_object_radius
var object_mass := 1 setget set_object_mass
var object_temperature := 0.0	# in celsius
var object_description := ""
var object_user_comment := ""


################################################################# PRIVATE VAR ############################################################
################################################################# ONREADY VAR ############################################################
onready var body := $Area2D
onready var collision_shape := $Area2D/CollisionShape2D
onready var sprite := $Area2D/Sprite
onready var satellites := $Area2D/Satellites
onready var name_label := $Area2D/NameLabel


################################################################# SETTERS & GETTERS ######################################################
func set_object_type(val:int) -> void:
	assert(val in ObjectType.values(), "Invalid object type: %d" % val)
	object_type = val
	satellites.visible = false if val == ObjectType.MOON else true


func set_object_name(val: String) -> void:
	assert(!val.empty(), "Object name cannot be empty")
	name = val
	object_name = val
	name_label.text = val


func set_object_radius(val: int) -> void:
	assert(val > 0, "Object radius must be greater than 0 (%d)" % val)
	object_radius = val
	collision_shape.shape.radius = object_radius
	name_label.rect_position.y = val + 10
	_rescale_sprite()


func set_object_mass(val: int) -> void:
	assert(val > 0, "System Objects must have mass greater than 0. You entered: %d" % val)
	object_mass = val


func set_object_orbit(val: int) -> void:
	assert(val >= 0, "Orbit height cannot have negative value: %d" % val)
	object_orbit = val
	body.position.x = val


################################################################# BUILT-IN METHODS #######################################################
func _ready() -> void:
	set_object_radius(object_radius)


################################################################# PUBLIC METHODS #########################################################
func get_object_type_as_str() -> String:
	var result := ""
	
	match object_type:
		ObjectType.STAR: result = "star"
		ObjectType.PLANET: result = "planet"
		ObjectType.MOON: result = "moon"
	
	return result


func can_have_satellites() -> bool:
	return satellites.visible


func add_satellite(sat: SystemObject) -> void:
	assert(can_have_satellites(), "System Objects of type %s cannot have sattelites" % get_object_type_as_str())
	satellites.add_child(sat)


func get_satellites() -> Array:
	return satellites.get_children()


func get_satellites_count() -> int:
	return satellites.get_child_count()


func get_max_satellites_mass() -> int:
	return int(object_mass * SATELLITES_MASS_FACTOR)


func toggle_physics(disable: bool) -> void:
	collision_shape.disabled = disable


################################################################# PRIVATE METHODS ########################################################
func _rescale_sprite() -> void:
	var body_diameter := object_radius * 2.0
	var scale_width: float = body_diameter / sprite.texture.get_width()
	var scale_height: float = body_diameter / sprite.texture.get_height()
	sprite.scale = Vector2(scale_width, scale_height)


func _on_VisibilityEnabler2D_screen_entered() -> void:
	pass


func _on_VisibilityEnabler2D_screen_exited() -> void:
	pass
