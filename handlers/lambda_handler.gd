class_name LambdaHandler
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

static func delete(node: Node) -> void:
	node.queue_free()

static func clear_handler_state(state: Dictionary) -> void:
	state.clear()
