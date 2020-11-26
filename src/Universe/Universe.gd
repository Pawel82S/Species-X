#class_name
extends Node2D
"""
Script description
"""
################################################################# SIGNALS ################################################################
################################################################# ENUMS ##################################################################
################################################################# CONSTANTS ##############################################################
const SCN_SOLAR_SYSTEM := preload("res://src/SolarSystem/SolarSystem.tscn")
const SCN_SYSTEM_IN_UNIV := preload("res://src/Universe/SystemInUniverse.tscn")
const GRID_SIZE := 55	# This gives us 55x55 = 3025 possible locations for systems
const HALF_GRID_SIZE := int(GRID_SIZE / 2)
const CENTER_SIZE := 5	# This must be odd number
const GRID_DISTANCE := 80	# Distance in px between grid points

################################################################# EXPORT VAR #############################################################
################################################################# PUBLIC VAR #############################################################
var add_system: FuncRef = null

################################################################# PRIVATE VAR ############################################################
var _grid := {}
var _total_planets := 0
var _total_moons := 0

################################################################# ONREADY VAR ############################################################
onready var solar_systems := $SolarSystems


################################################################# SETTERS & GETTERS ######################################################
################################################################# BUILT-IN METHODS #######################################################
func _ready() -> void:
	Func.ignore_result(Event.connect("show_system", self, "_on_show_system"))
	_create_grid()


################################################################# PUBLIC METHODS #########################################################
func create_solar_systems(amount: int) -> void:
	assert(add_system, "add_system function reference invalid")
	var names := SolarNames.new()
	for _i in range(amount):
		var system: SolarSystem = SCN_SOLAR_SYSTEM.instance()
		add_system.call_func(system)
		system.generate(names.random_star_name())
		_total_planets += system.get_planets_count()
		_total_moons += system.get_moons_count()
		system.visible = false
		_place_system_on_grid(system)


################################################################# PRIVATE METHODS ########################################################
func _create_grid() -> void:
	for x in range(-HALF_GRID_SIZE, HALF_GRID_SIZE + 1):
		for y in range(-HALF_GRID_SIZE, HALF_GRID_SIZE + 1):
			var pos := Vector2(x, y)
			if !_is_galaxy_center(pos, CENTER_SIZE):
				_grid[pos] = null


static func _is_galaxy_center(pos: Vector2, size: int) -> bool:
	assert(size % 2 != 0, "Center of galaxy must be odd number")
	var _range = int(size / 2)
	if pos.x >= -_range && pos.x <= _range && pos.y >= -_range && pos.y <= _range:
		return true
	else:
		return false


func _place_system_on_grid(system: SolarSystem) -> void:
	var x := 0
	var y := 0
	while _is_galaxy_center(Vector2(x, y), CENTER_SIZE) || _grid[Vector2(x, y)]:
		x = Func.randi_from_range(-HALF_GRID_SIZE, HALF_GRID_SIZE)
		y = Func.randi_from_range(-HALF_GRID_SIZE, HALF_GRID_SIZE)
	
	var pos := Vector2(x, y)
	_grid[pos] = system
	var system_icon := SCN_SYSTEM_IN_UNIV.instance()
	solar_systems.add_child(system_icon)
	system_icon.assign_system(system)
	system_icon.position = pos * GRID_DISTANCE


func _on_show_system(system: SolarSystem) -> void:
	visible = false
	system.visible = true
