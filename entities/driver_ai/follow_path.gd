extends Node

export var targets_container: NodePath

var ai: Node
var targets: Array
var current_index: float = 0

func _ready():
	targets = get_node(targets_container).get_children()
	ai = get_parent()

func _process(_delta):
	if ai.distance_to_target < 3:
		current_index += 1
		
	if current_index > targets.size() - 1:
		current_index = 0
		
	ai.current_target = targets[current_index]
