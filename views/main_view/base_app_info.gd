extends VBoxContainer

signal modified()

const Arg = preload("res://views/main_view/app_info_arg.tscn")

onready var app_name := $AppName as LineEdit

onready var file_path := $FileSelect/Path as LineEdit

onready var args := $Args as VBoxContainer
onready var arg_input := $ArgContainer/ArgInput as LineEdit

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready() -> void:
	file_path.connect("text_changed", self, "_on_file_path_changed")
	$FileSelect/Load.connect("pressed", self, "_on_load")

	arg_input.connect("text_entered", self, "_on_text_entered")
	_set_as_modifiable(arg_input, "text_entered")
	
	var add_arg_button := $ArgContainer/AddArg as Button
	add_arg_button.connect("pressed", self, "_on_add_arg")
	_set_as_modifiable(add_arg_button, "pressed")

func _to_string() -> String:
	return JSON.print({
		"app_name": app_name.text,
		"file_path": file_path.text,
		"args": args
	}, "\t")

###############################################################################
# Connections                                                                 #
###############################################################################

func _on_load() -> void:
	var popup: FileDialog = PopupHandler.create_file_selector()

	popup.connect("file_selected", self, "_on_popup_file_selected")
	_set_as_modifiable(popup, "file_selected")
	
	popup.current_path = ConfigHandler.data().default_search_path

	add_child(popup)
	popup.popup_centered_ratio()

func _on_popup_file_selected(text: String) -> void:
	file_path.text = text
	file_path.emit_signal("text_changed", text)

func _on_file_path_changed(text: String) -> void:
	if text.is_abs_path():
		app_name.text = text.get_file()

func _on_text_entered(text: String) -> void:
	if text.empty():
		return

	add_arg(text)
	
	arg_input.text = ""

func _on_add_arg() -> void:
	_on_text_entered(arg_input.text)

func _on_modified(_null = null) -> void:
	"""
	Callback for emitting the `modified` signal
	
	Params:
		_null - Required for some signals as they emit args
	"""
	emit_signal("modified")

###############################################################################
# Private functions                                                           #
###############################################################################

func _set_as_modifiable(control: Control, signal_name: String) -> void:
	control.connect(signal_name, self, "_on_modified")

###############################################################################
# Public functions                                                            #
###############################################################################

func add_arg(text: String) -> void:
	var arg := Arg.instance()
	args.add_child(arg)

	arg.line_edit.text = text
	arg.button.connect("pressed", LambdaHandler, "delete", [arg])
	_set_as_modifiable(arg.button, "pressed")

func get_data() -> AppConfig:
	var config := AppConfig.new()

	config.name = app_name.text
	config.path = file_path.text
	for c in args.get_children():
		config.args.append(c.to_string())

	return config
