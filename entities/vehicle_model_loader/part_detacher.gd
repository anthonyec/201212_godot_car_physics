# TODO: Should this be in VechicleModelLoader? Maybe it should be in the parent?

extends Node

func reparent(child: Node, new_parent: Node):
	var old_parent = child.get_parent()
	
	# TODO: Maybe add option to only hide/disable instead of removing
	old_parent.remove_child(child)
	new_parent.add_child(child)

func detatch_part(name: String) -> RigidBody:
	
	# TODO: Better way to reference the model? Is there a Godot standard to make
	# this script reusable?
	if !get_parent().has_node("Model") or !get_parent().get_node("Model").get_node(name):
		return null
		
	var model = get_parent().get_node("Model")
	var part: MeshInstance = model.get_node(name)
	var root = get_node("/root/Spatial") # TODO: A way to not hard-code this path?
	var original_transform = part.global_transform

	# Create RigidBody and CollisionShape and and set them up	
	var new_rigid_body = RigidBody.new()
	var new_collision_shape = CollisionShape.new()
	
	# Add RigidBody to VehicleModelLoader
	add_child(new_rigid_body)
	
	# Add part MeshInstance and CollisionShape to the RigidBody
	new_rigid_body.add_child(new_collision_shape)

	# Move the part MeshInstance into the RigidBody node
	reparent(part, new_rigid_body)

	# Reset MeshInstance position to collision shape position, which is correct
	part.global_transform = new_collision_shape.global_transform

	# Create a convex shape from the MeshInstance (which is a sibling node)
	new_collision_shape.make_convex_from_brothers()
	
	# Move the whole RigidBody to the world root node
	reparent(new_rigid_body, root)

	# Apply same position, rotation and scale of original MeshInstance part
	# Note, if the scale is not 1,1,1 when exporting then weird things will happen!
	new_rigid_body.global_transform = original_transform

	return new_rigid_body
