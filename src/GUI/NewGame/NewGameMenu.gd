#class_name
extends Control
"""
Script description
"""
################################################################# SIGNALS ################################################################
################################################################# ENUMS ##################################################################
################################################################# CONSTANTS ##############################################################
################################################################# EXPORT VAR #############################################################
################################################################# PUBLIC VAR #############################################################
################################################################# PRIVATE VAR ############################################################
################################################################# ONREADY VAR ############################################################
################################################################# SETTERS & GETTERS ######################################################
################################################################# BUILT-IN METHODS #######################################################
################################################################# PUBLIC METHODS #########################################################
################################################################# PRIVATE METHODS ########################################################
func _on_StartButton_pressed() -> void:
	Func.ignore_result(get_tree().change_scene("res://src/Game/Main.tscn"))
