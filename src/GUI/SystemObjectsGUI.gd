#class_name
extends Control
"""
Handles displaying solar system objects
"""
################################################################# SIGNALS ################################################################
################################################################# ENUMS ##################################################################
################################################################# CONSTANTS ##############################################################
################################################################# EXPORT VAR #############################################################
################################################################# PUBLIC VAR #############################################################
################################################################# PRIVATE VAR ############################################################
var _system: SolarSystem = null


################################################################# ONREADY VAR ############################################################
onready var filter_edit := $VBoxContainer/FilterEdit
onready var objects_tree := $VBoxContainer/ObjectsTree


################################################################# SETTERS & GETTERS ######################################################
################################################################# BUILT-IN METHODS #######################################################
func _ready() -> void:
	Func.ignore_result(Event.connect("system_changed", self, "_on_system_changed"))


################################################################# PUBLIC METHODS #########################################################
################################################################# PRIVATE METHODS ########################################################
func _on_system_changed(system_object: SolarSystem) -> void:
	if !system_object:
		visible = false
		objects_tree.clear()
		filter_edit.clear()
		_system = null
		return
	
	_system = system_object
	_display_objects()


func _display_objects() -> void:
	objects_tree.clear()
#	System can contain only one star (for now)
	var star: Star = _system.get_star()
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
	_display_objects()


func _on_ObjectsTree_item_selected() -> void:
	var item_name: String = objects_tree.get_selected().get_text(objects_tree.get_selected_column())
	Event.emit_signal("object_selected", item_name)


func _on_ObjectsTree_nothing_selected() -> void:
	Var.current_camera.follow_object = null
