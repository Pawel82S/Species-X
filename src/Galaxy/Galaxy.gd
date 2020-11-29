class_name Galaxy
extends Node2D
"""
Script description
"""
################################################################# SIGNALS ################################################################
################################################################# ENUMS ##################################################################
################################################################# CONSTANTS ##############################################################
const SCN_SYSTEM_IN_UNIV := preload("res://src/Galaxy/SystemInUniverse.tscn")
const GRID_SIZE := 55	# This gives us 55x55 = 3025 possible locations for systems
const HALF_GRID_SIZE := int(GRID_SIZE / 2)
const CENTER_SIZE := 5	# This must be odd number
const GRID_DISTANCE := 80	# Distance in px between grid points

################################################################# EXPORT VAR #############################################################
################################################################# PUBLIC VAR #############################################################
################################################################# PRIVATE VAR ############################################################
var _grid := {}

################################################################# ONREADY VAR ############################################################
onready var solar_systems := $SolarSystems

################################################################# SETTERS & GETTERS ######################################################
################################################################# BUILT-IN METHODS #######################################################
func _ready() -> void:
	Func.ignore_result(Event.connect("show_system", self, "_on_show_system"))
	_create_grid()


################################################################# PUBLIC METHODS #########################################################
func place_system_on_grid(system: SolarSystem) -> void:
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



func _on_show_system(system: SolarSystem) -> void:
	visible = false
	system.visible = true
