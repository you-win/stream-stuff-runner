class_name AppConfig
extends Reference

var name := ""
var path := ""
var args := []

func _init(data: Dictionary = {}) -> void:
	for key in data.keys():
		set(key, data[key])

func _to_string() -> String:
	return JSON.print(to_dict(), "\t")

func to_dict() -> Dictionary:
	return {
		"name": name,
		"path": path,
		"args": args
	}
