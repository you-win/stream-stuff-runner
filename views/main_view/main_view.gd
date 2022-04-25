extends VBoxContainer

const RegisterNewApp = preload("res://popups/register_new_app.tscn")
const AppInfo = preload("res://views/main_view/app_info.tscn")

onready var start_selected := $ScrollContainer/VBoxContainer/Actions/StartSelected as Button
onready var stop_selected := $ScrollContainer/VBoxContainer/Actions/StopSelected as Button

onready var registered_apps := $ScrollContainer/VBoxContainer/RegisteredApps as VBoxContainer

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready() -> void:
	$GlobalActions/StartAll.connect("pressed", self, "_on_start_all")
	$GlobalActions/StopAll.connect("pressed", self, "_on_stop_all")
	
	$ScrollContainer/VBoxContainer/Actions/SelectAll.connect("pressed", self, "_on_select_all")
	$ScrollContainer/VBoxContainer/Actions/DeselectAll.connect("pressed", self, "_on_deselect_all")
	start_selected.connect("pressed", self, "_on_start_selected")
	stop_selected.connect("pressed", self, "_on_stop_selected")
	
	$ScrollContainer/VBoxContainer/Actions/RegisterNew.connect("pressed", self, "_on_register_new")
	
	print(ConfigHandler.data())

	for arg in ConfigHandler.data().app_configs:
		_add_app_info(arg)

###############################################################################
# Connections                                                                 #
###############################################################################

func _on_start_all() -> void:
	for c in registered_apps.get_children():
		var config: AppConfig = c.get_data()
		if AppHandler.start(config) != OK:
			printerr("Unable to start %s" % config.name)

func _on_stop_all() -> void:
	AppHandler.stop_all()

func _on_select_all() -> void:
	for c in registered_apps.get_children():
		c.set_checked(true)

func _on_deselect_all() -> void:
	for c in registered_apps.get_children():
		c.set_checked(false)

func _on_start_selected() -> void:
	for config in _get_selected_apps():
		if AppHandler.start(config) != OK:
			printerr("Unable to start %s" % config.name)

func _on_stop_selected() -> void:
	for config in _get_selected_apps():
		if AppHandler.stop(config) != OK:
			printerr("Unable to stop %s" % config.name)

func _on_register_new() -> void:
	var popup := BasePopup.new("Register New App", RegisterNewApp)
	popup.connect("confirmed", self, "_on_popup_confirmed")
	add_child(popup)

func _on_popup_confirmed(val: AppConfig) -> void:
	if not val is AppConfig:
		printerr("Unexpected value %s" % str(val))
		return

	_add_app_info(val)

	ConfigHandler.data().app_configs.append(val)
	ConfigHandler.save()

###############################################################################
# Private functions                                                           #
###############################################################################

func _get_selected_apps() -> Array:
	"""
	Gets all apps that are currently selected

	Returns:
		Array - AppConfig of all selected apps
	"""
	var r := []
	
	for c in registered_apps.get_children():
		if c.is_checked():
			r.append(c.get_data())
	
	return r

func _add_app_info(app_config: AppConfig) -> void:
	var app_info := AppInfo.instance()
	registered_apps.add_child(app_info)

	var bap: Control = app_info.base_app_info

	bap.app_name.text = app_config.name
	bap.file_path.text = app_config.path
	for arg in app_config.args:
		bap.add_arg(arg)

###############################################################################
# Public functions                                                            #
###############################################################################
