extends Camera

export var target: NodePath
export var height: float = 2

func _process(delta):
	var target_object = get_node(target)
	self.global_transform.origin = target_object.global_transform.origin + (Vector3.UP * height)
