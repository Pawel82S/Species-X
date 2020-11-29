#class_name
extends Node
"""
Script description
"""
################################################################# SIGNALS ################################################################
################################################################# ENUMS ##################################################################
################################################################# CONSTANTS ##############################################################
const SCN_SOLAR_SYSTEM := preload("res://src/SolarSystem/SolarSystem.tscn")

################################################################# EXPORT VAR #############################################################
################################################################# PUBLIC VAR #############################################################
################################################################# PRIVATE VAR ############################################################
var _total_planets := 0
var _total_moons := 0
var _systems := {}

################################################################# ONREADY VAR ############################################################
onready var galaxy := $Galaxy
onready var solar_systems :=$SolarSystems
onready var gui_layer := $GUILayer
onready var main_menu := $GUILayer/MainMenu
onready var outliner := $GUILayer/Outliner
onready var camera := $Camera2D

################################################################# SETTERS & GETTERS ######################################################
################################################################# BUILT-IN METHODS #######################################################
func _ready() -> void:
	galaxy.name = Data.game.GalaxyName
	_create_solar_systems(Data.game.SolarSystems)
	outliner.solar_systems = _systems


################################################################# PUBLIC METHODS #########################################################
################################################################# PRIVATE METHODS ########################################################
func _create_solar_systems(amount: int) -> void:
	var names := SolarNames.new()
	for _i in range(amount):
		var system: SolarSystem = SCN_SOLAR_SYSTEM.instance()
		_add_system(system)
		system.generate(names.random_star_name())
		_systems[system.name] = system
		_total_planets += system.get_planets_count()
		_total_moons += system.get_moons_count()
		system.visible = false
		galaxy.place_system_on_grid(system)


func _add_system(sys: SolarSystem) -> void:
	solar_systems.add_child(sys)


func _on_Outliner_object_selected(outliner_mode: int, object_name: String) -> void:
	match outliner_mode:
		Const.OutlinerMode.GALAXY_VIEW:
			camera.follow_position = galaxy.solar_systems.get_node(object_name).global_position
		
		Const.OutlinerMode.SYSTEM_VIEW:
			pass
