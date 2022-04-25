class_name LogHandler
extends AbstractHandler

const MAX_LOGS: int = 1_000_000
const LOGS := []

const STATE := {
	"self": null,
	"status": null,
	"log_view": null
}

###############################################################################
# Builtin functions                                                           #
###############################################################################

###############################################################################
# Connections                                                                 #
###############################################################################

static func _on_redirect(text: String, is_error: bool) -> void:
	show("[%s] %s" % ["INFO" if not is_error else "ERROR", text])

###############################################################################
# Private functions                                                           #
###############################################################################

###############################################################################
# Public functions                                                            #
###############################################################################

static func init(args: Dictionary = {}) -> void:
	_inner_init(STATE, args)

	STATE.status.add_keyword_color("INFO", Color.green)
	STATE.status.add_keyword_color("ERROR", Color.red)

	STATE.log_view.add_keyword_color("INFO", Color.green)
	STATE.log_view.add_keyword_color("ERROR", Color.red)

	Redirect.connect("print_line", STATE.self, "_on_redirect")

static func show(text: String) -> void:
	STATE.log_view.text = "%s%s\n" % [STATE.log_view.text, text]
	STATE.status.text = text
	LOGS.append(text)
	
	if LOGS.size() > MAX_LOGS:
		printerr("Log spam approaching dangerous levels")
