extends Node

export var model_resource: Resource

var model

var left_side_selector = "_LEFT"
var right_side_selector = "_RIGHT"
var headlight_selector = "$_HEADLIGHT"
var brakelight_selector = "$_BRAKELIGHT"

func _ready():
	model = load(model_resource.resource_path).instance()
	
	add_child(model)
	
	create_headlights()
	create_breaklights()
	
#	open_door("DoorFrontLeft")
#	open_door("DoorFrontRight")

#	open_hood()
	
	pass
	
func _process(_delta):
	if (Input.is_action_just_pressed("ui_accept")):
		detatch_part("Hood")
		detatch_part("DoorFrontLeft")
		detatch_part("DoorFrontRight")
		detatch_part("BumperBack")
		detatch_part("BumperFront")
		pass
	
func reparent(child: Node, new_parent: Node):
	var old_parent = child.get_parent()
	old_parent.remove_child(child)
	new_parent.add_child(child)
	
func detatch_part(name: String) -> RigidBody: 
	var part: MeshInstance = model.get_node(name)
	
	if !part:
		return null
		
	var root = get_node("/root/Spatial") # A way to not hard-code this path?
	var original_position = part.global_transform
	
	# Create RigidBody and CollisionShape and and set them up	
	var new_rigid_body = RigidBody.new()
	var new_collision_shape = CollisionShape.new()
	add_child(new_rigid_body)
	new_rigid_body.add_child(part)
	new_rigid_body.add_child(new_collision_shape)
	
	# Move the part MeshInstance into the RigidBody node
	reparent(part, new_rigid_body)
	
	# Reset MeshInstance position to collision shape position, which is correct
	part.global_transform = new_collision_shape.global_transform
	
	# Create a convex shape from the MeshInstance (which is a sibling node)
	new_collision_shape.make_convex_from_brothers()
	
	# Move the whole RigidBody to the world root node
	reparent(new_rigid_body, root)
	
	new_rigid_body.global_transform = original_position
	
	return new_rigid_body
	
func open_hood():
	var hood: MeshInstance = model.get_node("Hood")
	hood.rotation_degrees.x = 90

func open_door(name: String):
	var door: MeshInstance = model.get_node(name)
	
	print(name.find("Right"))
	
	if name.find("Right") != -1:
		door.rotation_degrees.y = 90
	else:
		door.rotation_degrees.y = -90

func create_light_at_node_location(selector: String, new_name: String, settings: Dictionary):
	var node_position = model.get_node(selector)
	var new_light = SpotLight.new()
	new_light.set_name(new_name)
	new_light.light_color = settings.color
	add_child(new_light)
	new_light.global_transform = node_position.global_transform
	
func create_breaklights():
	var settings = {
		color = Color(1, 0, 0)
	}
	create_light_at_node_location(
		brakelight_selector + left_side_selector, 
		"BrakelightLeft",
		settings
	)
	create_light_at_node_location(
		brakelight_selector + right_side_selector,
		"BrakelightRight",
		settings
	)
	
func create_headlights():
	var settings = {
		color =Color(1, 1, 1)
	}
	create_light_at_node_location(
		headlight_selector + left_side_selector,
		"HeadlightLeft",
		settings
	)
	create_light_at_node_location(
		headlight_selector + right_side_selector,
		"HeadlightRight",
		settings
	)
	
