extends Node

# https://godotengine.org/qa/45609/how-do-you-rotate-spatial-node-around-axis-given-point-space
func rotate_around_old(obj, point, axis, angle):
	var rot = angle + obj.rotation.y 
	var tStart = point
	obj.global_translate(-tStart)
	obj.transform = obj.transform.rotated(axis, -rot)
	obj.global_translate(tStart)
	
# https://godotengine.org/qa/52262/is-there-any-equivalent-in-gdscript-the-rotatearound-method
func rotate_around(node, point, axis, angle):
	# Get transform
	var trans = node.global_transform

	# Rotate its basis
	var rotated_basis = trans.basis.rotated(axis, angle)

	# Rotate its origin
	var rotated_origin = point + (trans.origin - point).rotated(axis, angle)

	# Set the result back
	node.global_transform = Transform(rotated_basis, rotated_origin)

func open_door():
	pass
	
func close_door():
	pass
	

var original_transforms: Dictionary = {}

func cache_original_transform(node: Spatial):
	if !original_transforms.has(node.name):
		original_transforms[node.name] = node.transform
	else:
		node.transform = original_transforms[node.name]

func rotate_part(name: String, angle: float):
	var radians = deg2rad(angle)
	var part: MeshInstance = get_parent().get_node("Model").get_node(name)
	
	if !part:
		return null
	
	var pivot: Spatial = get_parent().get_node("Model").get_node("$_HINGE_" + name)
	var pivot_point: Vector3 = pivot.global_transform.origin
	var distance_from_pivot: float = part.global_transform.origin.distance_to(pivot_point)
	
	cache_original_transform(part)
		
	rotate_around(
		part,
		pivot_point,
		pivot.global_transform.basis.y,
		radians
	)
	
	pass
