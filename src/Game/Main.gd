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
	Func.ignore_result(Event.connect("show_system", self, "_on_show_system"))
	create_game()


################################################################# PUBLIC METHODS #########################################################
func create_game() -> void:
	galaxy.name = Data.game.GalaxyName
	_create_solar_systems(Data.game.SolarSystems)
	outliner.solar_systems = _systems


################################################################# PRIVATE METHODS ########################################################
func _create_solar_systems(amount: int) -> void:
	var names := SolarNames.new()
	for _i in range(amount):
		var system: SolarSystem = SCN_SOLAR_SYSTEM.instance()
		solar_systems.add_child(system)
		system.generate(names.random_star_name())
		_systems[system.name] = system
		_total_planets += system.get_planets_count()
		_total_moons += system.get_moons_count()
		system.visible = false
		galaxy.place_system_on_grid(system)
	
	print("Generated %d planets and %d moons in total" % [_total_planets, _total_moons])


func _on_Outliner_object_selected(outliner_mode: int, object_name: String) -> void:
	match outliner_mode:
		Const.OutlinerMode.GALAXY_VIEW:
			camera.follow_position = galaxy.solar_systems.get_node(object_name).global_position
		
		Const.OutlinerMode.SYSTEM_VIEW:
			camera.follow_position = _systems[outliner.system_name].get_object_position(object_name)


func _on_show_system(system_name: String) -> void:
	galaxy.visible = false
	camera.global_position = Vector2.ZERO
	outliner.system_name = system_name
	_systems[system_name].visible = true
