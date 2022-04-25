class_name BasePopup
extends WindowDialog

signal confirmed(value)

var screen: AbstractPopupScreen

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _init(p_name: String, p_screen: PackedScene) -> void:
	name = p_name
	window_title = p_name
	resizable = true
	anchor_bottom = 1.0
	anchor_right = 1.0
	
	var panel_container := PanelContainer.new()
	
	var style := StyleBoxFlat.new()
	style.content_margin_top = 5
	style.content_margin_bottom = 5
	style.content_margin_left = 5
	style.content_margin_right = 5
	style.bg_color = Color("333b4f")
	
	panel_container.set_indexed("custom_styles/panel", style)
	panel_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel_container.anchor_bottom = 1.0
	panel_container.anchor_right = 1.0
	
	add_child(panel_container)
	
	screen = p_screen.instance()
	if not screen is AbstractPopupScreen:
		printerr("Popup screen must be of type AbstractPopupScreen")
		return
	panel_container.add_child(screen)

func _ready() -> void:
	get_close_button().connect("pressed", LambdaHandler, "delete", [self])

	for i in ["modal_closed", "hide", "popup_hide"]:
		connect(i, LambdaHandler, "delete", [self])

	screen.connect("confirmed", self, "_on_confirm")
	screen.connect("cancelled", LambdaHandler, "delete", [self])

	popup_centered_ratio()

###############################################################################
# Connections                                                                 #
###############################################################################

func _on_confirm(value) -> void:
	"""
	Signal rebroadcaster for the inner AbstractPopupScreen
	"""
	emit_signal("confirmed", value)
	queue_free()

###############################################################################
# Private functions                                                           #
###############################################################################

###############################################################################
# Public functions                                                            #
###############################################################################
