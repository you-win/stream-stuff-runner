class_name ConfigHandler
extends AbstractHandler

const SAVE_PATH := "user://config.toml"
const DEBOUCE_TIME: float = 3.0

const STATE := {
	"main": null,
	"data": null, # ConfigData
	"debouncing": false
}

###############################################################################
# Builtin functions                                                           #
###############################################################################

###############################################################################
# Connections                                                                 #
###############################################################################

###############################################################################
# Private functions                                                           #
###############################################################################

static func _create_new_config() -> int:
	STATE.data = ConfigData.new()
	return save_instant()

###############################################################################
# Public functions                                                            #
###############################################################################

static func init(args: Dictionary = {}) -> void:
	_inner_init(STATE, args)

static func load() -> int:
	print("Loading config")

	var file := File.new()
	if file.open(SAVE_PATH, File.READ) != OK:
		printerr("%s does not exist, creating new config" % SAVE_PATH)
		return _create_new_config()
	
	var toml := TOML.new()
	var parse_result: TOMLParseResult = toml.parse(file.get_as_text())
	if parse_result.error != OK:
		printerr("Error occurred when parsing config at %s, creating new config\n%s" %
				[SAVE_PATH, parse_result.error_string])
		return _create_new_config()

	STATE.data = ConfigData.new(parse_result.result)

	print("Finished loading config")
	
	return OK

static func save() -> int:
	if STATE.debouncing:
		return
	STATE.debouncing = true
	
	print("Starting to save config")
	
	yield(STATE.main.get_tree().create_timer(DEBOUCE_TIME), "timeout")
	STATE.debouncing = false

	return save_instant()

static func save_instant() -> int:
	print("Saving config")

	var file := File.new()
	if file.open(SAVE_PATH, File.WRITE) != OK:
		printerr("Unable to write at path %s" % SAVE_PATH)
		return ERR_FILE_CANT_WRITE

	file.store_string(STATE.data.to_string())

	print("Finished saving config")

	return OK

static func data() -> ConfigData:
	return STATE.data
