extends ScrollContainer

const DEFAULT_SEARCH_PATH := "default_search_path"
onready var default_search_path := $List/DefaultSearchPath/LineEdit as LineEdit

const WINDOW_SIZE_X := "window_size_x"
onready var window_size_x := $List/WindowSize/VBoxContainer/X/LineEdit as LineEdit
const WINDOW_SIZE_Y := "window_size_y"
onready var window_size_y := $List/WindowSize/VBoxContainer/Y/LineEdit as LineEdit

const APP_STATUS_POLL_TIME := "app_status_poll_time"
onready var app_status_poll_time := $List/AppStatusPollTime/LineEdit as LineEdit

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready() -> void:
	var config: ConfigData = ConfigHandler.data()
	
	default_search_path.text = config.default_search_path
	default_search_path.connect("text_changed", self, "_on_text_changed", [DEFAULT_SEARCH_PATH])
	
	window_size_x.text = str(config.window_size_x)
	window_size_x.connect("text_changed", self, "_on_text_changed", [WINDOW_SIZE_X])
	window_size_y.text = str(config.window_size_y)
	window_size_y.connect("text_changed", self, "_on_text_changed", [WINDOW_SIZE_Y])
	
	app_status_poll_time.text = str(config.app_status_poll_time)
	app_status_poll_time.connect("text_changed", self, "_on_text_changed", [APP_STATUS_POLL_TIME])
	
	$List/ShowConfig.connect("pressed", self, "_on_show_config")
	$List/Restart.connect("pressed", self, "_on_restart")

###############################################################################
# Connections                                                                 #
###############################################################################

func _on_show_config() -> void:
	OS.shell_open(ProjectSettings.globalize_path("user://"))

func _on_restart() -> void:
	OS.shell_open(OS.get_executable_path())
	get_tree().quit()

func _on_text_changed(text: String, key: String) -> void:
	match key:
		DEFAULT_SEARCH_PATH:
			if text.is_abs_path():
				ConfigHandler.data().default_search_path = text
		WINDOW_SIZE_X, WINDOW_SIZE_Y, APP_STATUS_POLL_TIME:
			if text.is_valid_float():
				ConfigHandler.data().set(key, text.to_float())
		_:
			printerr("Unhandled setting changed")
	
	ConfigHandler.save()

###############################################################################
# Private functions                                                           #
###############################################################################

###############################################################################
# Public functions                                                            #
###############################################################################
