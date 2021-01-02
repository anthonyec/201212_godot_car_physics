extends Node

var vehicle: RigidBody

func _ready():
	vehicle = get_parent()

func _process_controls():
	var horizontal_axis = Input.get_action_strength("turn_left") - Input.get_action_strength("turn_right")
	var vertical_axis = Input.get_action_strength("accelerate") - Input.get_action_strength("brake")
	var handebrake_axis = Input.get_action_strength("handbrake")
	
	vehicle.wheel_turn = horizontal_axis
	vehicle.acceleration = vertical_axis
	vehicle.handebrake = handebrake_axis

func _process(_delta):
	_process_controls()
