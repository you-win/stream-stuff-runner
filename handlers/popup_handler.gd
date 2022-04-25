class_name PopupHandler
extends AbstractHandler

const STATE := {}

###############################################################################
# Builtin functions                                                           #
###############################################################################

###############################################################################
# Connections                                                                 #
###############################################################################

###############################################################################
# Private functions                                                           #
###############################################################################

###############################################################################
# Public functions                                                            #
###############################################################################

static func init(args: Dictionary = {}) -> void:
	_inner_init(STATE, args)

static func create_file_selector(options: Dictionary = {}) -> FileDialog:
	var fd := FileDialog.new()
	fd.access = FileDialog.ACCESS_FILESYSTEM
	fd.mode = FileDialog.MODE_OPEN_FILE

	for key in options.keys():
		fd.set(key, options[key])

	return fd
