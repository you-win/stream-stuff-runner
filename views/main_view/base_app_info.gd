extends VBoxContainer

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
	$ArgContainer/AddArg.connect("pressed", self, "_on_add_arg")

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

###############################################################################
# Private functions                                                           #
###############################################################################

###############################################################################
# Public functions                                                            #
###############################################################################

func add_arg(text: String) -> void:
	var arg := Arg.instance()
	args.add_child(arg)

	arg.line_edit.text = text
	arg.button.connect("pressed", LambdaHandler, "delete", [arg])

func get_data() -> AppConfig:
	var config := AppConfig.new()

	config.name = app_name.text
	config.path = file_path.text
	for c in args.get_children():
		config.args.append(c.to_string())

	return config
