class_name ConfigData
extends Reference

var other := {}

var app_configs := []

var default_search_path := ProjectSettings.globalize_path("user://")
var window_size_x: float = ProjectSettings.get_setting("display/window/size/width")
var window_size_y: float = ProjectSettings.get_setting("display/window/size/height")

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _init(data: Dictionary = {}) -> void:
	for key in data.keys():
		var val = data[key]
		match key:
			"app_configs":
				for i in val:
					app_configs.append(AppConfig.new(i))
			_:
				set(key, val)

func _to_string() -> String:
	return TOML.new().to_toml_string(to_dict())
	
###############################################################################
# Connections                                                                 #
###############################################################################

###############################################################################
# Private functions                                                           #
###############################################################################

###############################################################################
# Public functions                                                            #
###############################################################################

func to_dict() -> Dictionary:
	var app_configs_ := []
	for i in app_configs:
		app_configs_.append(i.to_dict())
	
	var r := {}
	for dict in get_property_list():
		if dict.name in GlobalConstants.IGNORED_REFERENCE_PROPS:
			continue
		if dict.name == "app_configs":
			continue
		
		r[dict.name] = get(dict.name)
	
	r["app_configs"] = app_configs_
	
	return r

func set_data(key: String, value) -> void:
	var prop = get(key)
	if prop != null:
		prop = value
	else:
		other[key] = value
