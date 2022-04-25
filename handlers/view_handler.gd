class_name ViewHandler
extends AbstractHandler

const STATE := {
	"pages": null,
	"current_page": null
}

###############################################################################
# Builtin functions                                                           #
###############################################################################

###############################################################################
# Connections                                                                 #
###############################################################################

static func _on_page_selected(tree: Tree) -> void:
	var page_name: String = tree.get_selected().get_text(tree.get_selected_column())
	
	if page_name.empty():
		return
	if STATE.current_page != null:
		STATE.current_page.hide()
	
	STATE.current_page = STATE.pages[page_name]
	STATE.current_page.show()

###############################################################################
# Private functions                                                           #
###############################################################################

###############################################################################
# Public functions                                                            #
###############################################################################

static func init(args: Dictionary = {}) -> void:
	_inner_init(STATE, args)
