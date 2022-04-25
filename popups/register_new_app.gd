extends AbstractPopupScreen

onready var base_app_info := $VBoxContainer/BaseAppInfo as VBoxContainer

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready() -> void:
	base_app_info.file_path.connect("text_changed", self, "_on_file_path_changed")

###############################################################################
# Connections                                                                 #
###############################################################################

func _on_confirm() -> void:
	emit_signal("confirmed", base_app_info.get_data())

func _on_file_path_changed(text: String) -> void:
	confirm.disabled = not text.is_abs_path()

###############################################################################
# Private functions                                                           #
###############################################################################

###############################################################################
# Public functions                                                            #
###############################################################################
