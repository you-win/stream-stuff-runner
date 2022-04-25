class_name OSHandler
extends AbstractOSHandler

const STATE := {
	"handler": null # AbstractOSHandler
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

###############################################################################
# Public functions                                                            #
###############################################################################

static func init(args: Dictionary = {}) -> void:
	_inner_init(STATE, args)

static func find_process(search_type: String, value: String) -> Array:
	return STATE.handler.find_process(search_type, value)

static func find_processes_by_name(process_name: String) -> Array:
	return STATE.handler.find_processes_by_name(process_name)

static func pid_exists(pid: int) -> bool:
	return STATE.handler.pid_exists(pid)

static func process_exists(process_name: String) -> bool:
	return STATE.handler.process_exists(process_name)
