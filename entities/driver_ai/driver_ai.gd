extends Node
class_name DriverAI

export var target: NodePath

var current_target: Spatial
var vehicle: RigidBody
var distance_to_target: float
var direction_to_target: Vector3
var facing: float

func _ready():
	current_target = get_node(target)
	vehicle = get_parent()
	
func _process(delta):
	if !current_target:
		return
	
	distance_to_target = vehicle.global_transform.origin.distance_to(
		current_target.global_transform.origin
	)
	direction_to_target = vehicle.global_transform.origin.direction_to(
		current_target.global_transform.origin
	).normalized()
	
	# Use the vehicle's X axis instead of Z to return a postivie or negative value
	facing = direction_to_target.dot(-vehicle.global_transform.basis.x.normalized())
	
	var space_state: PhysicsDirectSpaceState = get_node("/root").get_world().direct_space_state
	
	var result = space_state.intersect_ray(
		vehicle.global_transform.origin, 
		vehicle.global_transform.origin * -vehicle.global_transform.basis.z.normalized() * 5
	)
	
	print(result)
