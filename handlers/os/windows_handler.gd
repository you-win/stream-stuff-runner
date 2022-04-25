class_name WindowsHandler
extends AbstractOSHandler

const TASKLIST_COLUMNS := ["Image Name","PID","Session Name","Session#","Mem Usage"]

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

static func find_process(search_type: String, value: String) -> Array:
	"""
	Expected output is either:
	
	Found:
	
	"
	"Image Name","PID","Session Name","Session#","Mem Usage"
	"godot-custom-3.x.exe","20268","Console","1","298,832 K"
	"
	
	Not found -
	"
	INFO: No tasks are running which match the specified criteria.
	"
	
	Params:
		search_type: String - The search type to use. (pid, imagename)
		value: String - The search term
	
	Returns:
		Array - The parsed output. Each line is a Dictionary in the Array
	"""
	var r := []
	
	var output := []
	if OS.execute("tasklist", [
		"/fi",
		"\"",
		search_type,
		"eq",
		value,
		"\"",
		"/fo",
		"csv"
	], true, output) != OK:
		printerr("Unable to run OS command for pid_exists")
		return r
	
	if output.size() != 1:
		printerr("Unexpected output from find_process OS call %s" % str(output))
		return r
	
	var split_output: PoolStringArray = output[0].split("\n", false)
	if split_output.size() < 2:
		printerr("Unexpected split output from find_process OS call %s" % str(split_output))
		return r
	
	var columns: PoolStringArray = split_output[0].split(",")
	if columns.size() != TASKLIST_COLUMNS.size():
		printerr("Unexpected amount of columns for find_process")
		return r
	
	for i in columns.size():
		if columns[i].to_lower() != TASKLIST_COLUMNS[i].to_lower():
			printerr("Column name %s doesn't match expected)" % columns[i])
			return r
	
	var counter: int = 1
	while counter < split_output.size():
		var line: PoolStringArray = split_output[counter].split(",")
		var process_info := {}
		for i in line.size():
			process_info[TASKLIST_COLUMNS[i]] = line[i]
		
		r.append(process_info)
		counter += 1
	
	return r

static func find_processes_by_name(process_name: String) -> Array:
	return find_process("imagename", process_name)

static func pid_exists(pid: int) -> bool:
	"""
	Finds a process by pid if it exists. If there is more than one matching process,
	it is considered an error, since processes, in theory, cannot share PIDs.
	"""
	
	var output := find_process("pid", str(pid))
	if output.size() != 1:
		return false
	
	return true

static func process_exists(process_name: String) -> bool:
	var output := find_process("imagename", process_name)
	if output.size() < 1:
		return false
	
	return true
