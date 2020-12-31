extends Node

const PIVOT_SELECTOR = '$_PIVOT'
const DOOR_OPEN_ANGLE = 80
const HOOD_OPEN_ANGLE = 80

# https://godotengine.org/qa/52262/is-there-any-equivalent-in-gdscript-the-rotatearound-method
# Note: if you want it to work in global space regardless of parenting, use global_transform instead of transform.
func rotate_around(node, point, axis, angle):
	# Get transform
	var trans = node.global_transform

	# Rotate its basis
	var rotated_basis = trans.basis.rotated(axis, angle)

	# Rotate its origin
	var rotated_origin = point + (trans.origin - point).rotated(axis, angle)

	# Set the result back
	node.global_transform = Transform(rotated_basis, rotated_origin)
	
var original_transforms: Dictionary = {}

func cache_and_restore_original_transform(node: Spatial):
	if !original_transforms.has(node.name):
		original_transforms[node.name] = node.transform
	else:
		node.transform = original_transforms[node.name]

# TODO: Make this function more generic so it can be used elsewhere
func rotate_part(name: String, angle: float):
	var pivot_name = PIVOT_SELECTOR + "_" + name
	
	if !get_parent().has_node("Model"):
		return
		
	if !get_parent().get_node("Model").has_node(pivot_name):
		print("Can't find pivot point: " + pivot_name)
		return

	var radians = deg2rad(angle)
	
	# TODO: This hard-coded get_node makes this module very specfic, 
	# could it be more generic somehow?
	var model: Spatial = get_parent().get_node("Model")
	
	if !model:
		return null
		
	var part: MeshInstance = model.get_node(name)
	
	# Check part exists, it may have been detached!
	if !part:
		return null
	
	var pivot: Spatial = get_parent().get_node("Model").get_node(pivot_name)
	var pivot_point: Vector3 = pivot.global_transform.origin
	
	# Keep the original transformation and apply it before rotating.
	# Otherwise when rotating, it will add degrees to previous rotation, causing
	# it to spin around
	cache_and_restore_original_transform(part)
		
	rotate_around(
		part,
		pivot_point,
		pivot.global_transform.basis.y, # Local up direction of pivot point
		radians
	)

func is_left_side(name: String) -> bool:
	return name.to_lower().find("left") != -1

func open_door(name: String):
	var angle = -DOOR_OPEN_ANGLE if is_left_side(name) else DOOR_OPEN_ANGLE
	rotate_part(name, angle)
	
func close_door(name: String):
	rotate_part(name, 0)
	
func open_hood():
	rotate_part("Hood", HOOD_OPEN_ANGLE)

func close_hood():
	rotate_part("Hood", 0)
