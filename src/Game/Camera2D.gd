class_name MainCamera
extends Camera2D
"""
Camera can operate in 4 different modes:
	1) FOLLOW_SPACE - This mode works only in system view and follows point in space where camera was zoomed in or moved. It will let player
		avoid constant camera position adjustments due to orbital body rotation.
	2) FOLLOW_OBJECT - This mode works only in system view and follows selected object (planet, moon, fleet etc.)
	3) VIEW_PLANET - This mode works only in system view and shows one planet with all its moons and surroundings using icons to represent
		objects that would normally be much smaller or invisible (Camera zoom is disabled).
	4) VIEW_ALL - This mode works in galaxy and system view. In galaxy veiw it shows icons of star in each system and in system view player
		can see whole system with star and planets represented by icons (moons are not shown, VIEW_PLANET is for it). Camera zoom is disabled.
"""
################################################################# SIGNALS ################################################################
################################################################# ENUMS ##################################################################
enum Mode {
	FOLLOW_INPUT,
	FOLLOW_OBJECT,
	VIEW_PLANET,
	VIEW_ALL,
}
################################################################# CONSTANTS ##############################################################
const MOVE_SPEED := 500
const ZOOM_STEP = 0.1
const ZOOM_VEC = Vector2(ZOOM_STEP, ZOOM_STEP)
const MAX_ZOOM = Vector2(10, 10)

################################################################# EXPORT VAR #############################################################
################################################################# PUBLIC VAR #############################################################
var follow_object = null setget set_follow_object

################################################################# PRIVATE VAR ############################################################
var _mode: int = Mode.FOLLOW_INPUT
var _direction := Vector2.ZERO

################################################################# ONREADY VAR ############################################################
################################################################# SETTERS & GETTERS ######################################################
func set_follow_object(val) -> void:
	follow_object = val
	_mode = Mode.FOLLOW_OBJECT if val else Mode.FOLLOW_INPUT


################################################################# BUILT-IN METHODS #######################################################
func _ready() -> void:
	Var.current_camera = self


func _physics_process(delta: float) -> void:
	if _direction != Vector2.ZERO:
		_mode = Mode.FOLLOW_INPUT
	
	match _mode:
		Mode.FOLLOW_INPUT:
			position += _direction * MOVE_SPEED * delta
		
		Mode.FOLLOW_OBJECT:
			global_position = follow_object.body.global_position


func _unhandled_input(event: InputEvent) -> void:
	if _mode == Mode.FOLLOW_INPUT:
		_direction = Vector2(
						Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
						Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
					).normalized()
	
	if event.is_action("ZoomOut"):
		zoom -= ZOOM_VEC
		zoom -= ZOOM_VEC if zoom > ZOOM_VEC * 2 else -ZOOM_VEC
	elif event.is_action("ZoomIn"):
		zoom += ZOOM_VEC
#		zoom += ZOOM_VEC if zoom < MAX_ZOOM else Vector2.ZERO


################################################################# PUBLIC METHODS #########################################################
################################################################# PRIVATE METHODS ########################################################
