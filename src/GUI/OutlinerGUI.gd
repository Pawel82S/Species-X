#class_name
extends Control
"""
To control what content is displayed set solar_system variable to SolarSystem object you want to show or set it to null for Galaxy overveiw.
"""
################################################################# SIGNALS ################################################################
signal object_selected(outliner_mode, object_name)
#signal show_system(system_name)

################################################################# ENUMS ##################################################################
################################################################# CONSTANTS ##############################################################
################################################################# EXPORT VAR #############################################################
################################################################# PUBLIC VAR #############################################################
var solar_systems := {} setget set_solar_system
var system_name := "" setget set_system_name

################################################################# PRIVATE VAR ############################################################
var _mode: int = Const.OutlinerMode.GALAXY_VIEW setget set_mode

################################################################# ONREADY VAR ############################################################
onready var filter_edit := $VBoxContainer/FilterEdit
onready var objects_tree := $VBoxContainer/ObjectsTree


################################################################# SETTERS & GETTERS ######################################################
func set_solar_system(val: Dictionary) -> void:
	assert(!val.empty(), "Assigning empty dictionary")
	solar_systems = val
	update_gui()


func set_system_name(val: String) -> void:
	system_name = val
	_mode = Const.OutlinerMode.SYSTEM_VIEW
	update_gui()


func set_mode(val: int) -> void:
	assert(val in Const.OutlinerMode.values(), "Unknown mode %d" % val)
	_mode = val
	update_gui()


################################################################# BUILT-IN METHODS #######################################################
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("ui_cancel"):
		filter_edit.focus_mode = Control.FOCUS_NONE
		filter_edit.focus_mode = Control.FOCUS_CLICK
	elif event.is_action("galaxy_map"):
		_mode = Const.OutlinerMode.GALAXY_VIEW
		update_gui()


################################################################# PUBLIC METHODS #########################################################
func update_gui() -> void:
	if !visible:
		return
	
	objects_tree.clear()
	
	match _mode:
		Const.OutlinerMode.GALAXY_VIEW:
			_display_galaxy_objects()
		
		Const.OutlinerMode.SYSTEM_VIEW:
			_display_system_objects()
		
		_: assert(false, "Invalid mode %d" % _mode)


################################################################# PRIVATE METHODS ########################################################
func _display_galaxy_objects() -> void:
	var root = objects_tree.create_item()
	objects_tree.hide_root = true
	for sys_name in solar_systems.keys():
		var system_item = objects_tree.create_item(root)
		system_item.set_text(0, sys_name)


func _display_system_objects() -> void:
	var star: Star = solar_systems[system_name].get_star()
	var root = objects_tree.create_item()
	objects_tree.hide_root = true
	var star_item = objects_tree.create_item(root)
	star_item.set_text(0, star.name)

	for planet in star.get_satellites():
		var planet_item = objects_tree.create_item(star_item)
		planet_item.set_text(0, planet.name)

		for moon in planet.get_satellites():
			if filter_edit.text.empty() || filter_edit.text.is_subsequence_of(moon.name):
				var moon_item = objects_tree.create_item(planet_item)
				moon_item.set_text(0, moon.name)


func _on_FilterEdit_text_changed(_new_text: String) -> void:
	update_gui()


func _on_ObjectsTree_item_selected() -> void:
	var item_name: String = objects_tree.get_selected().get_text(objects_tree.get_selected_column())
	emit_signal("object_selected", _mode, item_name)


func _on_ObjectsTree_nothing_selected() -> void:
	Var.current_camera.follow_object = null
