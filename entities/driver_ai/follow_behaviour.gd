extends Node

var ai: Node

# Distance until reaching max acceleration
var max_distance = 10

func _ready():
	ai = get_parent()

func _process(_delta):
	var distance_percent = clamp(ai.distance_to_target / max_distance, 0, 1)
	
	ai.vehicle.wheel_turn = ai.facing
	ai.vehicle.acceleration = 0.3 # distance_percent
	
	if abs(ai.facing) > 0.8:
		ai.vehicle.handebrake = 1
	else:
		ai.vehicle.handebrake = 0
