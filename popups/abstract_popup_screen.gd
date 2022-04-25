class_name AbstractPopupScreen
extends ScrollContainer

signal confirmed(val)
signal cancelled()

onready var confirm := $VBoxContainer/ConfirmCancel/Confirm as Button
onready var cancel := $VBoxContainer/ConfirmCancel/Cancel as Button

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready() -> void:
	confirm.connect("pressed", self, "_on_confirm")
	cancel.connect("pressed", self, "_on_cancel")

###############################################################################
# Connections                                                                 #
###############################################################################

func _on_confirm() -> void:
	printerr("Not yet implemented %s" % name)

func _on_inner_confirm(_val) -> void:
	printerr("Not yet implemented %s" % name)

func _on_cancel() -> void:
	emit_signal("cancelled")

###############################################################################
# Private functions                                                           #
###############################################################################

###############################################################################
# Public functions                                                            #
###############################################################################
