extends CanvasLayer

#region Node paths

export var background_path: NodePath

#region Title bar

export var title_bar_path: NodePath
export var minimize_path: NodePath
export var close_path: NodePath

#endregion

#region Views

export var main_container_path: NodePath
export var tree_path: NodePath

export var logs_path: NodePath

export var status_path: NodePath

#endregion

#endregion

const TREE_COL: int = 0

onready var background = get_node(background_path) as ColorRect

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _init() -> void:
	OS.center_window()
	
	ConfigHandler.init({
		"main": self
	})
	ConfigHandler.load()

func _ready() -> void:
	LogHandler.init({
		"self": LogHandler,
		"status": get_node(status_path),
		"log_view": get_node(logs_path)
	})
	
	_setup_window()
	
	#region View
	
	var pages := {}
	
	var main_container: Control = get_node(main_container_path)
	_setup_main_container(main_container, pages)
	
	# Needs to wait until the MainContainer is setup
	ViewHandler.init({
		"pages": pages,
		"current_page": pages["Main View"]
	})

	PopupHandler.init()

	#endregion
	
	print("%s started successfully" % ProjectSettings.get_setting("application/config/name"))

func add_child(node: Node, legible_unique_name: bool = false) -> void:
	background.add_child(node, legible_unique_name)

###############################################################################
# Connections                                                                 #
###############################################################################

###############################################################################
# Private functions                                                           #
###############################################################################

func _setup_window() -> void:
	var title_bar = get_node(title_bar_path)
	title_bar.connect("gui_input", WindowHandler, "_on_title_bar_input")
	
	var minimize = get_node(minimize_path)
	minimize.connect("pressed", WindowHandler, "_on_minimize")
	
	var close = get_node(close_path)
	close.connect("pressed", WindowHandler, "_on_close", [self])

func _setup_main_container(main_container: Control, pages: Dictionary) -> void:
	for c in main_container.get_children():
		if c is Tree:
			continue
		
		pages[c.name.capitalize()] = c
	
	var tree: Tree = get_node(tree_path)
	tree.hide_root = true
	var root: TreeItem = tree.create_item()
	
	for page_name in pages.keys():
		var page: TreeItem = tree.create_item(root)
		page.set_text(TREE_COL, page_name.capitalize())
	
	tree.connect("item_selected", ViewHandler, "_on_page_selected", [tree])

###############################################################################
# Public functions                                                            #
###############################################################################
