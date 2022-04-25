class_name WindowHandler
extends AbstractHandler

const STATE := {
	"title_bar_mouse_down": false,
	"title_bar_mouse_offset": Vector2.ZERO
}

###############################################################################
# Builtin functions                                                           #
###############################################################################

###############################################################################
# Connections                                                                 #
###############################################################################

static func _on_title_bar_input(ie: InputEvent) -> void:
	if not ie is InputEventMouse:
		return
	
	if ie is InputEventMouseButton and ie.button_index == BUTTON_LEFT:
		if STATE.title_bar_mouse_down != ie.pressed:
			STATE.title_bar_mouse_offset = ie.global_position
		STATE.title_bar_mouse_down = ie.pressed
	elif STATE.title_bar_mouse_down:
		OS.window_position = lerp(OS.window_position, OS.window_position + ie.global_position - STATE.title_bar_mouse_offset, 0.5)

static func _on_minimize() -> void:
	OS.window_minimized = true

static func _on_close(node: Node) -> void:
	node.get_tree().quit()

###############################################################################
# Private functions                                                           #
###############################################################################

###############################################################################
# Public functions                                                            #
###############################################################################

static func init(args: Dictionary = {}) -> void:
	_inner_init(STATE, args)
