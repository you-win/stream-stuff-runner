class_name ConfigData
extends Reference

var other := {}

var app_configs := []

func _init(data: Dictionary = {}) -> void:
	for key in data.keys():
		var val = data[key]
		match key:
			"app_configs":
				for i in val:
					app_configs.append(AppConfig.new(i))
			"other":
				other = val
			_:
				printerr("Unhandled key %s" % key)

func _to_string() -> String:
	return TOML.new().to_toml_string(to_dict())

func to_dict() -> Dictionary:
	var app_configs_ := []
	for i in app_configs:
		app_configs_.append(i.to_dict())
	return {
		"other": other,
		"app_configs": app_configs_
	}

func set_data(key: String, value) -> void:
	var prop = get(key)
	if prop != null:
		prop = value
	else:
		other[key] = value
