extends VBoxContainer

const RegisterNewApp = preload("res://popups/register_new_app.tscn")
const AppInfo = preload("res://views/main_view/app_info.tscn")

onready var start_selected := $ScrollContainer/VBoxContainer/Actions/StartSelected as Button
onready var stop_selected := $ScrollContainer/VBoxContainer/Actions/StopSelected as Button

onready var registered_apps := $ScrollContainer/VBoxContainer/RegisteredApps as VBoxContainer

var _checked_boxes: int = 0

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready() -> void:
	$GlobalActions/StartAll.connect("pressed", self, "_on_start_all")
	$GlobalActions/StopAll.connect("pressed", self, "_on_stop_all")
	$GlobalActions/RefreshStatus.connect("pressed", self, "_on_app_status_poll")
	
	$ScrollContainer/VBoxContainer/Actions/SelectAll.connect("pressed", self, "_on_select_all")
	$ScrollContainer/VBoxContainer/Actions/DeselectAll.connect("pressed", self, "_on_deselect_all")
	start_selected.connect("pressed", self, "_on_start_selected")
	stop_selected.connect("pressed", self, "_on_stop_selected")
	
	$ScrollContainer/VBoxContainer/Actions/RegisterNew.connect("pressed", self, "_on_register_new")

	for arg in ConfigHandler.data().app_configs:
		_add_app_info(arg)

###############################################################################
# Connections                                                                 #
###############################################################################

func _on_start_all() -> void:
	print("Starting all apps")
	
	for c in registered_apps.get_children():
		var config: AppConfig = c.get_data()
		if AppHandler.start(config) != OK:
			printerr("Unable to start %s" % config.name)
			return
		c.set_running(true)
		print("Started %s" % config.name)
	
	print("Finished starting all apps")

func _on_stop_all() -> void:
	print("Stopping all apps")
	
	AppHandler.stop_all()
	for c in registered_apps.get_children():
		c.set_running(false)
		print("Assuming %s is stopped" % c.get_data().name)
	
	print("Finished stopping all apps")

func _on_select_all() -> void:
	for c in registered_apps.get_children():
		c.set_checked(true)

func _on_deselect_all() -> void:
	for c in registered_apps.get_children():
		c.set_checked(false)

func _on_start_selected() -> void:
	print("Starting selected apps")
	
	for c in _get_selected_apps():
		var config: AppConfig = c.get_data()
		if AppHandler.start(config) != OK:
			printerr("Unable to start %s" % config.name)
			return
		c.set_running(true)
		print("Started %s" % config.name)
	
	print("Finished starting selected apps")

func _on_stop_selected() -> void:
	print("Stopping selected apps")
	
	for c in _get_selected_apps():
		var config: AppConfig = c.get_data()
		if AppHandler.stop(config) != OK:
			printerr("Assuming %s is already stopped" % config.name)
		c.set_running(false)
		print("Stopped %s" % config.name)
	
	print("Finished stopping selected apps")

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

func _on_check_box_toggled(state: bool) -> void:
	_checked_boxes += 1 if state else -1
	
	start_selected.disabled = false if _checked_boxes > 0 else true
	stop_selected.disabled = false if _checked_boxes > 0 else true

func _on_app_status_poll() -> void:
	print("Polling app status")
	
	var pids: Dictionary = AppHandler.STATE.pids
	var non_existent_pids := {}
	for pid_key in pids.keys():
		if not OSHandler.pid_exists(pids[pid_key]):
			printerr("%s is no longer running but it was expected to still be alive" % pid_key)
			non_existent_pids[pid_key] = pids[pid_key]
	
	for key in non_existent_pids.keys():
		AppHandler.STATE.pids.erase(key)
		
		var found := false
		for c in registered_apps.get_children():
			if c.get_data().name == key:
				c.set_running(false)
				found = true
				break
		if found != true:
			printerr("Unable to update UI during app status poll")
	
	print("Finished polling app status")

###############################################################################
# Private functions                                                           #
###############################################################################

func _get_selected_apps() -> Array:
	"""
	Gets all apps that are currently selected

	Returns:
		Array - All selected apps
	"""
	var r := []
	
	for c in registered_apps.get_children():
		if c.is_checked():
			r.append(c)
	
	return r

func _add_app_info(app_config: AppConfig) -> void:
	var app_info := AppInfo.instance()
	registered_apps.add_child(app_info)

	var bap: Control = app_info.base_app_info

	bap.app_name.text = app_config.name
	bap.file_path.text = app_config.path
	for arg in app_config.args:
		bap.add_arg(arg)
	
	app_info.check_box.connect("toggled", self, "_on_check_box_toggled")

###############################################################################
# Public functions                                                            #
###############################################################################
