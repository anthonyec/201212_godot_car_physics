extends Node
class_name DriverAI

export var target: NodePath

# Distance until reaching max acceleration
var max_distance = 10

var current_target: Spatial
var vehicle: RigidBody

func _ready():
	current_target = get_node(target)
	vehicle = get_parent()
	
func _process(delta):
	var distance_to_target = vehicle.global_transform.origin.distance_to(
		current_target.global_transform.origin
	)
	var direction_to_target = vehicle.global_transform.origin.direction_to(
		current_target.global_transform.origin
	).normalized()
	
	# Use the vehicle's X axis instead of Z to return a postivie or negative value
	var facing = direction_to_target.dot(-vehicle.global_transform.basis.x.normalized())
	var distance_percent = clamp(distance_to_target / max_distance, 0, 1)
	
	vehicle.wheel_turn = facing
	vehicle.acceleration = distance_percent
	
	if abs(facing) > 0.8:
		vehicle.handebrake = 1
	else:
		vehicle.handebrake = 0
		
	DebugDraw.set_text("facing", facing)
	DebugDraw.set_text("distance_to_target", distance_percent)

	pass
