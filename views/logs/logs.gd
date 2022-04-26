extends VBoxContainer

onready var logs := $Logs as TextEdit

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready() -> void:
	$HBoxContainer/Open.connect("pressed", self, "_on_open")
	$HBoxContainer/Copy.connect("pressed", self, "_on_copy")
	$HBoxContainer/Clear.connect("pressed", self, "_on_clear")

###############################################################################
# Connections                                                                 #
###############################################################################

func _on_open() -> void:
	OS.shell_open(ProjectSettings.globalize_path("user://logs/godot.log"))

func _on_copy() -> void:
	OS.clipboard = logs.text

func _on_clear() -> void:
	logs.text = ""

###############################################################################
# Private functions                                                           #
###############################################################################

###############################################################################
# Public functions                                                            #
###############################################################################
