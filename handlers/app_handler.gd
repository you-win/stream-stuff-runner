class_name AppHandler
extends AbstractHandler

const STATE := {
	"pids": {}
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

static func start(config: AppConfig) -> int:
	var pid: int = OS.execute(config.path, config.args, false)
	if pid < 0:
		printerr("Unable to start %s" % config.to_string())
		return ERR_CANT_CREATE

	STATE.pids[config.name] = pid

	return OK

static func stop(config: AppConfig) -> int:
	if not STATE.pids.has(config.name):
		printerr("Process not running")
		return ERR_DOES_NOT_EXIST

	if OS.kill(STATE.pids[config.name]) != OK:
		printerr("Unable to kill %s - %d" % [config.name, STATE.pids[config.name]])
		return ERR_DOES_NOT_EXIST

	STATE.pids.erase(config.name)
	
	return OK

static func stop_all() -> void:
	var killed_pids := [] # pid name: String
	for key in STATE.pids.keys():
		if OS.kill(STATE.pids[key]) != OK:
			printerr("Unable to kill %s - %d" % [key, STATE.pids[key]])
			continue
		killed_pids.append(key)

	for pid_name in killed_pids:
		STATE.pids.erase(pid_name)
