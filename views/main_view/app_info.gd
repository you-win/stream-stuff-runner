extends HBoxContainer

onready var check_box := $CheckBox as CheckBox
onready var base_app_info := $BaseAppInfo

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready() -> void:
	$BaseAppInfo/Delete.connect("pressed", self, "_on_delete")

func _to_string() -> String:
	return JSON.print({
		"check_box": check_box,
		"base_app_info": base_app_info
	}, "\t")

###############################################################################
# Connections                                                                 #
###############################################################################

func _on_delete() -> void:
	var data := get_data()
	var app_configs: Array = ConfigHandler.data().app_configs
	
	var found := false
	for i in app_configs:
		if i.name == data.name:
			app_configs.erase(i)
			found = true
			break
	
	if not found:
		printerr("Unable to delete %s, app config not found")
		return
	
	ConfigHandler.save()
	
	queue_free()

###############################################################################
# Private functions                                                           #
###############################################################################

###############################################################################
# Public functions                                                            #
###############################################################################

func set_checked(value: bool) -> void:
	check_box.pressed = value

func is_checked() -> bool:
	return check_box.pressed

func get_data() -> AppConfig:
	return base_app_info.get_data()
