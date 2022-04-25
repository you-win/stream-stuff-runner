class_name AbstractOSHandler
extends AbstractHandler

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

static func find_process(search_type: String, value: String) -> Array:
	printerr("find_process not yet implemented")
	return []

static func find_processes_by_name(process_name: String) -> Array:
	printerr("find_processes_by_name not yet implemented")
	return []

static func pid_exists(pid: int) -> bool:
	printerr("pid_exists not yet implemented")
	return false

static func process_exists(process_name: String) -> bool:
	printerr("process_exists not yet implemented")
	return false
